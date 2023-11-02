"""
DESCRIPTION
---------------------------------------------------------------------------------------------------------
This code trains a machine learning model, specifically a Convolutional Graph Neural Network (CGCNN),
to predict formation energies or related properties for quantum materials. It's designed to run in a 
distributed computing environment, accessible across all spawned Julia processes.
"""

# Distributed computing: total 7 workers process for parallel computation
using Distributed
addprocs(7)

@everywhere begin
    using CSV, DataFrames
    using CUDA
    using Random, Statistics
    using Flux
    using Flux: @epochs
    using AtomGraphs                                                             
    using ChemistryFeaturization
    using AtomicGraphNets
end

@everywhere function train_formation_energy(;
    num_pts,
    IE,EA,VO,GR,RO,BL,CR,X,VA,
    num_epochs = 50,
    data_dir = "./qmof/",                                                      
    verbose = true
)

    """
    PARAMETER
    ---------------------------------------------------------------------------------------------------------------
    num_pts                   : Number of data points to use from the dataset
    IE,EA,VO,GR,RO,BL,CR,X,VA : Feature parameters or descriptors related to material properties
    num_epochs                : Number of training epochs
    data_dir                  : Directory containing the dataset and related files (replace this w/ your directory)
    verbose                   : Flag to control the verbosity of output for monitoring training progress

    OUTPUT
    ---------------------------------------------------------------------------------------------------------------
    model                     : The trained machine learning model
    result                    : An array of strings indicating different stages and metrics of the training process
    """

    # Signal the start of the process
    println("Setting things up...")
    result = ["Setting things up..."]                                           

    # Data-related options: define the training/testing split
    train_frac = 0.8  # Fraction of the dataset to be used for trainin
    num_train = Int32(round(train_frac * num_pts))
    num_test = num_pts - num_train

    # Target properties and dataset identifiers
    target = "qmof"                                                                                
    prop = "outputs.pbe.bandgap"                                                                   
    id = "qmof_id"  # Field by which to label each input material                                   

    # Set up the featurization with provided parameters
    featurization = GraphNodeFeaturization([IE,EA,VO,GR,RO,BL,CR,X,VA])
    num_features = output_shape(featurization)

    # Set up model hyperparameters
    num_conv = 3 
    crys_fea_len = 32
    num_hidden_layers = 1
    opt = ADAM(0.001)  

    # Read dataset and shuffle data, picking a subset for training/testing
    info = CSV.read(string(data_dir, target, ".csv"), DataFrame)                                   
    y = Array(Float32.(info[!, Symbol(prop)]))
    indices = shuffle(1:size(info, 1))[1:num_pts]                
    info = info[indices, :]
    output = y[indices]

    # Build graphs and feature vectors from structures
    if verbose
        println("Building graphs and feature vectors from structures...")
        push!(result, "Building graphs and feature vectors from structures...")
    end
    inputs = FeaturizedAtoms[]

    for r in eachrow(info)
        cifpath = string(data_dir, "relaxed_structures/", r[Symbol(id)], ".cif")                   
        gr = AtomGraph(cifpath)
        input = featurize(gr, featurization)
        push!(inputs, input)
    end

    # Divide the dataset into train/test sets
    if verbose
        println("Dividing into train/test sets...")
        push!(result, "Dividing into train/test sets...")
    end
    train_output = output[1:num_train]
    test_output = output[num_train+1:end]
    train_input = inputs[1:num_train]
    test_input = inputs[num_train+1:end]
    train_data = zip(train_input, train_output)

    # Build the network model
    if verbose
        println("Building the network...")
    end
    model = build_CGCNN(
        num_features,
        num_conv = num_conv,
        atom_conv_feature_length = crys_fea_len,
        pooled_feature_length = (Int(crys_fea_len / 2)),
        num_hidden_layers = 1,
    )

    # Define loss function and callback for progress monitoring
    loss_mse(x, y) = Flux.Losses.mse(model(x), y)
    loss_mae(x, y) = Flux.Losses.mae(model(x), y)                              
    evalcb_verbose() = push!(result, string("MSE:",mean(loss_mse.(test_input, test_output)), "\n", "MAE:", mean(loss_mae.(test_input, test_output))))   
    evalcb_quiet() = return nothing
    evalcb = verbose ? evalcb_verbose : evalcb_quiet
    evalcb()

    # Train the model
    if verbose
        println("Training!")
        push!(result, "Training!")
    end
    for i in 1:num_epochs 
        push!(result, string("EPOCH:", i))
        Flux.train!(
            loss_mae,
            Flux.params(model),
            train_data,
            opt,
            cb = Flux.throttle(evalcb, 50),                                   
        )
    end

    # Signal the end of the process
    println("The end")
    push!(result, "The end")
    return model, result
end

