
autocorr_array = [];

for i = 1:size(y_history_array,1)
    autocorr_array(i,:) = xcorr(y_history_array(i,:));
    [a,lags] = xcorr(y_history_array(1,:));
end

f = figure("name","autocorrelation y")
plot(lags,mean(autocorr_array))