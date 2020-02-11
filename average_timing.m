load time_results/times2analize.mat

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

%load (sprintf('first_order_seqquences.mat'));
%first_order_seq_freq