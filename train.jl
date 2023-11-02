"""
DESCRIPTION
--------------------------------------------------------------------------------------------
This loop initiates a parallel computing process. 
"""

# Directory for saving output files (replace this w/ your directory)
data_dir = "..."

@sync @distributed for i = 0:7
    # Call 'train_formation_energy' function
    model, results = train_formation_energy(num_pts = 20375, IE=I, EA=EA, VO=V, GR=G, RO=P ,BL=B ,CR=R ,X=X, VA=VA)
    
    # Construct the filepath for the output file, unique for each worker process
    filepath = string(data_dir, "20000_", i, ".txt")

    # Write the results of the training process to a text file
    open(filepath, "w") do f
        for res in results
          println(f, res)
        end
    end
end