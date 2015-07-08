function cascadeface_24net(varargin)

% -------------------------------------------------------------------------
% Part 4.1: prepare the data
% -------------------------------------------------------------------------

% Load character dataset
imdb = load('./audio_data_dp_new.mat') ;
imdb = imdb.M;
imdb.meta.sets=['train','val'];
ss = size(imdb.images.label);
imdb.images.set = ones(1,ss(2));
imdb.images.set(ceil(rand(1,800)*ss(2))) = 2;
% -------------------------------------------------------------------------
% Part 4.2: initialize a CNN architecture
% -------------------------------------------------------------------------

net = f24net() ;

% -------------------------------------------------------------------------
% Part 4.3: train and evaluate the CNN
% -------------------------------------------------------------------------

trainOpts.batchSize = 128 ;
trainOpts.numEpochs = 45 ;
trainOpts.continue = false ;
trainOpts.learningRate = [0.001*ones(1,30),0.0001*ones(1,10),0.0001*ones(1,5)] ;
trainOpts.expDir = 'data/24net-experiment-normB_new' ;
trainOpts = vl_argparse(trainOpts, varargin);

% Take the average image out
imageMean = mean(imdb.images.data(:)) ;
imdb.images.data = imdb.images.data - imageMean ;

% Call training function in MatConvNet
[net,info] = cnn_train(net, imdb, @getBatch, trainOpts) ;

% Save the result for later use
net.layers(end) = [] ;
net.layers{end+1} = struct('type', 'softmax') ;
net.imageMean = imageMean ;
save('data/24net-experiment-normB_new/f24net.mat', '-struct', 'net') ;

% -------------------------------------------------------------------------
% Part 4.4: visualize the learned filters
% -------------------------------------------------------------------------

figure(2) ; clf ; colormap gray ;
vl_imarraysc(squeeze(net.layers{1}.weights{1}),'spacing',2)
axis equal ; title('filters in the first layer') ;

% -------------------------------------------------------------------------
% Part 4.5: apply the model
% -------------------------------------------------------------------------

% Load the CNN learned before
net = load('data/24net-experiment-normB/f24net.mat') ;

% Load the sentence
im = imread('data/test3.png');
im = imresize(im,[24 24]);
im = im2single(im) ;
im = 256 * (im - net.imageMean) ;

% Apply the CNN to the larger image
res = vl_simplenn(net, im) ;
[value,index]=max(res(end).x);

% --------------------------------------------------------------------
function [im, labels] = getBatch(imdb, batch)
% --------------------------------------------------------------------
im = imdb.images.data(:,:,batch) ;
im = 256 * reshape(im, 24, 24, 1, []) ;
labels = imdb.images.label(1,batch) ;
