% Con il metodo del supervisore, devi ricordarti di commentare delle righe e non fare clear
% Con questo metodo invece la prima volta MATLAB crea il file e le volte successive lo rilegge quindi usa sempre gli stessi samples.
% ATTENZIONE Questo funziona bene solo se nei prossimi dataset (DSF, TOA, BOA) le righe saranno nello stesso ordine del dataset RAdCor.


%% Data Preperation

splitFile = "random_split_70_30.mat";

if isfile(splitFile)

    load(splitFile, "idxTrain", "idxVal")

else

    N = size(X,1);

    idx = randperm(N);

    Ntrain = round(0.7*N);

    idxTrain = idx(1:Ntrain);

    idxVal = idx(Ntrain+1:end);

    save(splitFile, "idxTrain", "idxVal")

end

Xtrain = X(idxTrain,:);
Ytrain = Y(idxTrain,:);

Xval = X(idxVal,:);
Yval = Y(idxVal,:);
