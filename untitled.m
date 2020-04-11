load(sprintf("time_results/times2analize_hourly_numentaTM.mat"));

fprintf("Previous Amount of trials saved: %d\n",size(every_htm_time,1));

start_trial = 1;

avg_every_htm_time = mean(every_htm_time(start_trial:10,:),1);
avg_every_htm_time_notrn = mean(every_htm_time_notrn(start_trial:10,:),1);
avg_every_sm_r_time = mean(every_sm_r_time(start_trial:10,:),1);
avg_every_sm_r_time_notrn = mean(every_sm_r_time_notrn(start_trial:10,:),1);

avg_speed_up = avg_every_htm_time-avg_every_sm_r_time;
avg_speed_up_notrn = avg_every_htm_time_notrn-avg_every_sm_r_time_notrn;

fprintf("Average Time difference of sm_r vs HTM: %s\n",avg_speed_up);
fprintf("\n");
fprintf("Average Time difference w/o training of sm_r vs HTM: %s\n",avg_speed_up_notrn);
fprintf("\n");

fprintf("Number of Datasets w/o improvement: %d\n",sum(avg_speed_up < 0,2));
fprintf("Number of Datasets w/o training w/o improvement: %d\n",sum(avg_speed_up_notrn < 0,2));