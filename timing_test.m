function timing_test (startFile, endFile)

fid = fopen('matlabHTM/fileList.txt', 'r');
i = 1;
while ~feof(fid)
    fscanf(fid, '%d ', 1); % skip the line count in the first column
    fileNames{i} = fscanf(fid, '%s ', 1);
    i = i+1;
end
fclose (fid);
%fprintf(1, '\n %d files to process in total', i);
close all;

matlabHTM_timing_dataset_temp = 0;
htm_time_notrn_temp = 0;
htmau_timing_dataset_temp = 0;
htmau_time_notrn_temp = 0;

%anomalyScores_all_temp = 0;


for i=startFile:endFile
    [~, name, ~] = fileparts(fileNames{i});
    load(sprintf("htmau/Output/time_SMRM_%s.mat",name));
    load(sprintf("matlabHTM/Output/time_HTM_%s.mat",name));


    matlabHTM_timing_dataset_temp = [matlabHTM_timing_dataset_temp matlabHTM_timing_dataset];
    htm_time_notrn_temp = [htm_time_notrn_temp htm_time_notrn];
    htmau_timing_dataset_temp = [htmau_timing_dataset_temp htmau_timing_dataset];
    htmau_time_notrn_temp = [htmau_time_notrn_temp htmau_time_notrn];
    
    underscore_locations = strfind(fileNames{i},'_');
    
    if fileNames{i}(underscore_locations(1)+1:underscore_locations(2)-1) == "numentaTM"
        % This information is processed in bootstapping
    else        
        load (sprintf('htmau/Output/HTM_SM_%s.mat', name), 'anomalyScores');
        prediction_pct(anomalyScores);
        load (sprintf('matlabHTM/Output/HTM_SM_%s.mat', name), 'anomalyScores');
        prediction_pct(anomalyScores);
    end
    
end



matlabHTM_timing_dataset = matlabHTM_timing_dataset_temp(2:size(matlabHTM_timing_dataset_temp,2));
htm_time_notrn = htm_time_notrn_temp(2:size(htm_time_notrn_temp,2));
htmau_timing_dataset = htmau_timing_dataset_temp(2:size(htmau_timing_dataset_temp,2));
htmau_time_notrn = htmau_time_notrn_temp(2:size(htmau_time_notrn_temp,2));

if fileNames{i}(underscore_locations(1)+1:underscore_locations(2)-1) == "numentaTM"
    times_saving(fileNames{i},matlabHTM_timing_dataset,htm_time_notrn,htmau_timing_dataset,htmau_time_notrn);
else        
    load (sprintf('htmau/Output/HTM_SM_%s.mat', name), 'anomalyScores');
    prediction_pct(anomalyScores);
    load (sprintf('matlabHTM/Output/HTM_SM_%s.mat', name), 'anomalyScores');
    prediction_pct(anomalyScores);

    times_saving(fileNames{i},matlabHTM_timing_dataset,htm_time_notrn,htmau_timing_dataset,htmau_time_notrn);
end


%exit


function prediction_pct(anomalyScores)
    testing_start = min (750, round(0.02*size(anomalyScores,2)));
    testing_anomalyScores = anomalyScores(testing_start:size(anomalyScores,2));

    mean_prediction = 100*(1-mean(testing_anomalyScores));
    full_predictions = sum(testing_anomalyScores==0);
    predictions_90 = sum(testing_anomalyScores<0.1);
    predictions_50 = sum(testing_anomalyScores<0.5);
    some_prediction = sum(testing_anomalyScores~=1);

    full_predictions_pct = full_predictions/size(testing_anomalyScores,2);
    predictions_90_pct = predictions_90/size(testing_anomalyScores,2);
    predictions_50_pct = predictions_50/size(testing_anomalyScores,2);
    some_prediction_pct = some_prediction/size(testing_anomalyScores,2);

    fprintf("\nThe avegae of prediction is <strong> %.2f </strong>",mean_prediction);
    fprintf("\nPercentage of fully predicted events: <strong> %d </strong>",full_predictions_pct);
    fprintf("\nPercentage of 90%% event prediction <strong> %d </strong>",predictions_90_pct);
    fprintf("\nPercentage of 50%% event prediction <strong> %d </strong>",predictions_50_pct);
    fprintf("\nPercentage of any prediction <strong> %d </strong>",some_prediction_pct);

    
function times_saving(file_name,matlabHTM_timing_dataset,htm_time_notrn,htmau_timing_dataset,htmau_time_notrn)
    underscore_locations = strfind(file_name,'_');
    
    load(sprintf("time_results/times2analize_%s.mat",...
    file_name(underscore_locations(1)+1:underscore_locations(2)-1)));

    fprintf("Previous Amount of trials saved: %d\n",size(every_htm_time,1));

    flag_htm = ~isequal(every_htm_time (size(every_htm_time,1),:),matlabHTM_timing_dataset);
    flag_htm_notrn = ~isequal(every_htm_time_notrn (size(every_htm_time_notrn,1),:),htm_time_notrn);
    flag_htmau = ~isequal(every_htmau_time (size(every_htmau_time,1),:),htmau_timing_dataset);
    flag_htmau_notrn = ~isequal(every_htmau_time_notrn (size(every_htmau_time_notrn,1),:),htmau_time_notrn);

    flag_size_htm = (size(every_htm_time,2) == size(matlabHTM_timing_dataset,2));
    flag_size_htm_notrn = (size(every_htm_time_notrn,2) == size(htm_time_notrn,2));
    flag_size_htmau = (size(every_htmau_time,2) == size(htmau_timing_dataset,2));
    flag_size_htmau_notrn = (size(every_htmau_time_notrn,2) == size(htmau_time_notrn,2));


    if flag_htm && flag_htm_notrn && flag_htmau && flag_htmau_notrn && flag_size_htm && flag_size_htm_notrn...
        && flag_size_htmau && flag_size_htmau_notrn
        every_htm_time = [every_htm_time; matlabHTM_timing_dataset];
        every_htm_time_notrn = [every_htm_time_notrn; htm_time_notrn];
        every_htmau_time = [every_htmau_time; htmau_timing_dataset];
        every_htmau_time_notrn = [every_htmau_time_notrn; htmau_time_notrn];

        fprintf("New Amount of trials saved: %d\n",size(every_htm_time,1));
        save (sprintf("time_results/times2analize_%s.mat",...
        file_name(underscore_locations(1)+1:underscore_locations(2)-1)),...
        'every_htm_time','every_htmau_time','every_htm_time_notrn','every_htmau_time_notrn');
    end
    
    avg_every_htm_time = mean(every_htm_time,1);
    avg_every_htm_time_notrn = mean(every_htm_time_notrn,1);
    avg_every_htmau_time = mean(every_htmau_time,1);
    avg_every_htmau_time_notrn = mean(every_htmau_time_notrn,1);

    avg_speed_up = diff([avg_every_htmau_time; avg_every_htm_time]);
    avg_speed_up_notrn = diff([avg_every_htmau_time_notrn; avg_every_htm_time_notrn]);

    fprintf("Average Time difference of HTMAU vs HTM: %s\n",avg_speed_up);
    fprintf("\n");
    fprintf("Average Time difference w/o training of HTMAU vs HTM: %s\n",avg_speed_up_notrn);
    fprintf("\n");

    fprintf("Number of Datasets w/o improvement: %d\n",sum(avg_speed_up < 0,2));
    fprintf("Number of Datasets w/o training w/o improvement: %d\n",sum(avg_speed_up_notrn < 0,2));
