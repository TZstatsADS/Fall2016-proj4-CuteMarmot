# Project: Words 4 Music

### Code lib Folder

The lib directory contains various files with function definitions (but only function definitions - no code that actually runs).

Firstly, I selected four feathers as my input. They are Loudness_max, Loudness_max_time, Segments_Pitches and Segments_Timbre. Because the dimension of each variables are from 4 to 3990, I repeat and cut them into 2000. The process is named 1read_feature.R.
Then, I did k-means cluster to these four feathers. And change the dimention of dataset timbre and pitches from 2350*2000*12 to 2350 * 24000. For each feather, the number of cluster is 10. So, I have the data set called “input_data.RData”. The process is named Prepare input data.R.
And then, I did topic modeling for the outcome. There are 19 cluster in it. I name the label data set “label_outcome”. This process is named topic modeling.R.
Then, I used xgboost to make a model and then selected parameters. This process is named modeling.R.
Then, I will apply this model to the test data set and give each songs a cluster. After that, I will calculate the mean ranking of the songs in different clusters. Then use the mean ranking of it’s cluster as it’s predicted ranking. This process is named Final preiction.R.

In the process of testing, there are four R filds called read_feature_test.R, Prepare input data_test.R, topic modeling_test.R and final_test.R. Topic modeling_test.R at here is unuseful.
