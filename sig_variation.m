% startFile = 1;
% endFile = 58;
% 
% fid = fopen('htmau/fileList.txt', 'r');
% i = 1;
% while ~feof(fid)
%     fscanf(fid, '%d ', 1); % skip the line count in the first column
%     fileNames{i} = fscanf(fid, '%s ', 1);
%     fileNames{i} = strcat("htmau/",fileNames{i});
%     readData = importdata (fileNames{i});
%     
%     data_size = size(readData.data, 1);
%     date_time = readData.textdata (2:data_size+1, 1);
%     raw_date = datevec(date_time); %[y, month, d, timeOfDay, m, s]e
%     
%     raw_date(:,3) = weekday(date_time);
%     raw_date(:,5) = ((raw_date(:,3) == 1) + (raw_date(:,3) == 7)) + 1.0; %weekend 
%     % energy, month, day of the week, time of day, weekend, seconds (not used)
%     raw_date (:, 4) = raw_date (:, 4); 
%     raw_date (:, 1) = readData.data (:,1);
%     
%     mean_value(i) = mean(readData.data (:,1));
%     std_value(i) = std(readData.data (:, 1));
%     
%     mean_time(i) = mean(raw_date (:, 4));
%     std_time(i) = std(raw_date (:, 4));
%     
%     value_coef_variation(i) =  100*(std_value(i)/mean_value(i));
%     time_coef_variation(i) = 100*(std_time(i)/mean_time(i));
%     
%     i = i+1;
% end

% save (sprintf('variation.mat'),'value_coef_variation','time_coef_variation','mean_value','std_value','mean_time','std_time');

load variation.mat

load time_results/times2analize.mat

avg_every_htm_time = mean(every_htm_time,1);
avg_every_htm_time_notrn = mean(every_htm_time_notrn,1);
avg_every_htmau_time = mean(every_htmau_time,1);
avg_every_htmau_time_notrn = mean(every_htmau_time_notrn,1);

avg_speed_up = diff([avg_every_htmau_time; avg_every_htm_time]);
avg_speed_up_notrn = diff([avg_every_htmau_time_notrn; avg_every_htm_time_notrn]);


value = [value_coef_variation;datenum(avg_speed_up(1:58));datenum(avg_speed_up_notrn)];
time = [time_coef_variation;datenum(avg_speed_up(1:58));datenum(avg_speed_up_notrn)];

sorted_value = sortrows(value',1);
sorted_time = sortrows(time',1);

combined_mean = (value(1,:)'+time(1,:)')/2;
combined_std = (value(2,:)'.^2+value(1,:)'.^2)+(time(2,:)'.^2+time(1,:)'.^2)/2;
comb_coef_var = 100*(combined_std./combined_mean);

h1 = figure(1);
ax1 = axes("Parent", h1);
plot(ax1,comb_coef_var,value(2,:)','red','linewidth',2 )
xlabel('coef_variation_value');
ylabel('speed_up');

% h2 = figure(2);
% ax2 = axes("Parent", h2);
% plot(ax2,sorted_time(:,1),sorted_time(:,2),'red','linewidth',2 )
% xlabel('coef_variation_time');
% ylabel('speed_up');