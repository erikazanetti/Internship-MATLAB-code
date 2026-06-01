%% Random split: 70% training, 30% validation

rng(1) %%rende il random split ripetibile quindi la prossima volta vengono scelti gli stessi samples importante per confrontare esperimenti

N = size(X, 1);

idx = randperm(N); %%crea lista casuale di numeri da 1 a N

Ntrain = round(0.70 * N);

idxTrain = idx(1:Ntrain);
idxVal = idx(Ntrain+1:end);

Xtrain_raw = X(idxTrain, :);
Ytrain_raw = Y(idxTrain, :);

Xval_raw = X(idxVal, :);
Yval_raw = Y(idxVal, :);

disp("Size of Xtrain_raw:")
disp(size(Xtrain_raw))

disp("Size of Ytrain_raw:")
disp(size(Ytrain_raw))

disp("Size of Xval_raw:")
disp(size(Xval_raw))

disp("Size of Yval_raw:")
disp(size(Yval_raw))
