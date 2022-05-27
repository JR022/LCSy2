estimateSpeeds <- function(wordLength,alphabetSize,lenR,stateArray,displacementArray,initialState) {
#'wordLength' - the length of the word that the frog dynamics follow.  The word itself is unimportant as stateArray' dicates how the frogs behave.
#'alphabetSize' - the size of the alphabet (numbers start at 0).
#'lenR' - the length of the word R used for the dynamics.
#'stateArray' - a 2D array whose elements indicate what the state becomes after a symbol is applied.  A[i,j] = [X_{n+1} | (X_n,a) = (f_i,j)].
#'displacementArray' - a 3D array whose elements indicate the displacement of frog.  A[i,j,k] = D_i(f_k,j).
#'initialState' - the state f_i (whose transition array is stateArray[i]) representing the initial state of the frog dynamics.  Numbering starts from 1.
	
	frogDisplacements <- array(0,wordLength) #Used to store the total displacement of frog i at A[i].
	currentState <- initialState
    i <- 0
    print("Starting.")
    start_time <- Sys.time()
	for (Rindex in 1:lenR) {
		#Generate a symbol of R and apply it to the frogs.
        Rsymbol = floor(runif(1,min=0,max=alphabetSize)) #Generate a random symbol of R.  This starts from 0 (max is alphabetSize as the upper bound needs to be one higher).
		for (frogIndex in 1:wordLength) { #Add the frogs' displacements.
			frogDisplacements[frogIndex] = sum(frogDisplacements[frogIndex],displacementArray[frogIndex,Rsymbol+1,currentState])
    	}
        #Debugging lines.
        #print(sprintf("Symbol %d.  Changing from state %d to %d.",Rsymbol+1,currentState,stateArray[currentState,Rsymbol+1]))
        #print(sprintf("%d,",displacementArray[,Rsymbol+1,currentState]))
    	currentState <- stateArray[currentState,Rsymbol+1] #Work out the new state of the chain.
     }
	#Now compute each s_i.
	speeds <- array(0,wordLength)
	for (i in 1:wordLength) {
		speeds[i] <- frogDisplacements[i]/lenR
    }
    print(sprintf("Duration %f seconds.",difftime(Sys.time(), start_time, units = "secs")))
	return(speeds)
}
estimateSpeeds(4,3,1e6,array(c(6,4,3,3,6,6,5,3,2,5,5,4,3,3,4,6,3,6),dim=c(6,3)),array(c(1,0,0,3,0,0,3,1,0,2,0,2,0,1,0,3,0,0,3,1,1,1,0,2,1,1,1,1,0,0,1,3,0,1,1,2,1,0,0,3,0,1,2,1,0,0,2,2,1,0,1,2,0,0,0,4,0,2,1,1,0,0,0,4,0,0,2,2,1,1,1,1),dim=c(4,3,6)),1)
