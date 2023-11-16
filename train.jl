"""
DESCRIPTION
--------------------------------------------------------------------------------------------
This loop initiates a parallel computing process. 
"""

# Directory for saving output files 
data_dir = "..."  # Replace "..." with the directory where you want to save output files

@sync @distributed for i = 0:7
    # Call 'train_formation_energy' function
    model, results = train_formation_energy(num_pts = 20375, IE=I, EA=EA, VO=V, GR=G, RO=P ,BL=B ,CR=R ,X=X, VA=VA)
    
    # Construct the filepath for the output file, unique for each worker process
    filepath = string(data_dir, i, ".txt")  # Modify this line to assign the desired file name to each worker

    # Write the results of the training process to a text file
    open(filepath, "w") do f
        for res in results
          println(f, res)
        end
    end
end
