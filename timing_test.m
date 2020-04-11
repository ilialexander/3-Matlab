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
sm_time = zeros(startFile,endFile);
sm_r_timing_dataset_temp = 0;
sm_r_time_notrn_temp = 0;
rmsm_time = zeros(startFile,endFile);

%anomalyScores_all_temp = 0;


for i=startFile:endFile
    [~, name, ~] = fileparts(fileNames{i});
    load(sprintf("htmau/Output/time_SMRM_%s.mat",name));
    load(sprintf("matlabHTM/Output/time_HTM_%s.mat",name));
%    load (sprintf('htmau/Output/HTM_SM_%s.mat', name), 'AU');
%    load (sprintf('matlabHTM/Output/HTM_SM_%s.mat', name), 'SM');


    matlabHTM_timing_dataset_temp = [matlabHTM_timing_dataset_temp matlabHTM_timing_dataset];
    htm_time_notrn_temp = [htm_time_notrn_temp htm_time_notrn];
%    sm_time(i) = sum(SM.time);
    sm_r_timing_dataset_temp = [sm_r_timing_dataset_temp sm_r_timing_dataset];
    sm_r_time_notrn_temp = [sm_r_time_notrn_temp sm_r_time_notrn];
%    rmsm_time(i) = sum(AU.time);
    
    underscore_locations = strfind(fileNames{i},'_');
    
    if fileNames{i}(underscore_locations(1)+1:underscore_locations(2)-1) == "numentaTM"
        % This information is processed in bootstapping
    else        
        load (sprintf('htmau/Output/HTM_SM_%s.mat', name), 'anomalyScores');
        prediction_pct(anomalyScores);
        csvwrite(sprintf('htmau/Output/%s_anomalyScores.csv', name), anomalyScores');
        load (sprintf('matlabHTM/Output/HTM_SM_%s.mat', name), 'anomalyScores');
        prediction_pct(anomalyScores);
        csvwrite(sprintf('matlabHTM/Output/%s_anomalyScores.csv', name), anomalyScores');
    end
    
end

matlabHTM_timing_dataset = matlabHTM_timing_dataset_temp(2:size(matlabHTM_timing_dataset_temp,2));
htm_time_notrn = htm_time_notrn_temp(2:size(htm_time_notrn_temp,2));
sm_r_timing_dataset = sm_r_timing_dataset_temp(2:size(sm_r_timing_dataset_temp,2));
sm_r_time_notrn = sm_r_time_notrn_temp(2:size(sm_r_time_notrn_temp,2));

if fileNames{i}(underscore_locations(1)+1:underscore_locations(2)-1) == "numentaTM"
    times_saving(fileNames{i},matlabHTM_timing_dataset,htm_time_notrn,sm_r_timing_dataset,sm_r_time_notrn);
else        
    load (sprintf('htmau/Output/HTM_SM_%s.mat', name), 'anomalyScores');
    prediction_pct(anomalyScores);
    load (sprintf('matlabHTM/Output/HTM_SM_%s.mat', name), 'anomalyScores');
    prediction_pct(anomalyScores);

    times_saving(fileNames{i},matlabHTM_timing_dataset,htm_time_notrn,sm_r_timing_dataset,sm_r_time_notrn);
end


exit


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

    
function times_saving(file_name,matlabHTM_timing_dataset,htm_time_notrn,sm_r_timing_dataset,sm_r_time_notrn)
    underscore_locations = strfind(file_name,'_');
    
    load(sprintf("time_results/times2analize_%s.mat",...
    file_name(strfind(file_name,'/')+1:underscore_locations(2)-1)));

    fprintf("Previous Amount of trials saved: %d\n",size(every_htm_time,1));

    flag_htm = ~isequal(every_htm_time (size(every_htm_time,1),:),matlabHTM_timing_dataset);
    flag_htm_notrn = ~isequal(every_htm_time_notrn (size(every_htm_time_notrn,1),:),htm_time_notrn);
    flag_sm_r = ~isequal(every_sm_r_time (size(every_sm_r_time,1),:),sm_r_timing_dataset);
    flag_sm_r_notrn = ~isequal(every_sm_r_time_notrn (size(every_sm_r_time_notrn,1),:),sm_r_time_notrn);

    flag_size_htm = (size(every_htm_time,2) == size(matlabHTM_timing_dataset,2));
    flag_size_htm_notrn = (size(every_htm_time_notrn,2) == size(htm_time_notrn,2));
    flag_size_sm_r = (size(every_sm_r_time,2) == size(sm_r_timing_dataset,2));
    flag_size_sm_r_notrn = (size(every_sm_r_time_notrn,2) == size(sm_r_time_notrn,2));


    if flag_htm && flag_htm_notrn && flag_sm_r && flag_sm_r_notrn && flag_size_htm && flag_size_htm_notrn...
        && flag_size_sm_r && flag_size_sm_r_notrn
        every_htm_time = [every_htm_time; matlabHTM_timing_dataset];
        every_htm_time_notrn = [every_htm_time_notrn; htm_time_notrn];
        every_sm_r_time = [every_sm_r_time; sm_r_timing_dataset];
        every_sm_r_time_notrn = [every_sm_r_time_notrn; sm_r_time_notrn];

        fprintf("New Amount of trials saved: %d\n",size(every_htm_time,1));
        save (sprintf("time_results/times2analize_%s.mat",...
        file_name(strfind(file_name,'/')+1:underscore_locations(2)-1)),...
        'every_htm_time','every_sm_r_time','every_htm_time_notrn','every_sm_r_time_notrn');
    end
    
    avg_every_htm_time = mean(every_htm_time,1);
    avg_every_htm_time_notrn = mean(every_htm_time_notrn,1);
    avg_every_sm_r_time = mean(every_sm_r_time,1);
    avg_every_sm_r_time_notrn = mean(every_sm_r_time_notrn,1);

    avg_speed_up = avg_every_htm_time-avg_every_sm_r_time;
    avg_speed_up_notrn = avg_every_htm_time_notrn-avg_every_sm_r_time_notrn;
    
    writematrix ([avg_every_htm_time_notrn' avg_every_sm_r_time_notrn'],sprintf("time_results/times2analize_avg_%s.csv",...
        file_name(strfind(file_name,'/')+1:underscore_locations(2)-1)));

    fprintf("Average Time difference of sm_r vs HTM: %s\n",avg_speed_up);
    fprintf("\n");
    fprintf("Average Time difference w/o training of sm_r vs HTM: %s\n",avg_speed_up_notrn);
    fprintf("\n");

    fprintf("Number of Datasets w/o improvement: %d\n",sum(avg_speed_up < 0,2));
    fprintf("Number of Datasets w/o training w/o improvement: %d\n",sum(avg_speed_up_notrn < 0,2));
