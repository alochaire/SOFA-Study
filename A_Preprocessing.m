close all
clear
clc

home_dir='/Work/Studien/Alondra/EEG_DATA_new';
study_name='DMS_Training';


subjects={...
    1,'hox956';...
    2,'vhp563';...
    3,'zxu637';...
    4,'hdd890';...
    6,'pjn299';...
    7,'vbo819';...
    8,'mqg010';...
    9,'knk882';...
    10,'vpg057';...
    11,'uzf564';...
    12,'plr729';...
    13,'fis877';...
    14,'tkn982';...
    15,'zye479';...
    16,'uhm826';...
    17,'gdu570';...
    18,'qfw523';...
    19,'zti042';...
    20,'vzk959';...
    21,'stw021';...
    22,'vri238';...
    23,'nmh955';...
    24,'rgg013';...
    25,'gld976';...
    26,'yvq851';...
    27,'awf230';...
    28,'zig187';...
    29,'xdp808';...
    30,'gqe481';...
    31,'ogn704';...
    32,'pyd907';...
    33,'nwq680';...
    34,'tma549';...
    35,'cze808';...
    36,'igv205';...
    37,'gts521';...
    38,'vpr343';...
    39,'fct763';...
    40,'gok669';...
    41,'qun440';...
    42,'xrx314';...
    43,'hcv514';...
    44,'mfm012';...
    };







% 0) channel location
% 1) Filter
% 2) interpolate bad channels
% 3) epoching for all possible events
% 4) Artifact rejection (statistical thresholds and/or visual inspection)
% 5) Artifact correction (regression, PCA, ICA)
% 6) re-reference  (LMST, Nix, half LMAST)
% 7) Baseline correction
% 8) ERP component measurements
% 9) Statistical analyses


%%% falls man neu beginnen muss können hier die alten ordner gelöscht
%%%
%%% werden

delete_all=0;

if delete_all==1
    %%% alle eeglab folder löschen
    for sub=1:length(subjects)
        eval(['cd (''',char(home_dir),'/vpn',num2str(subjects(sub)),''')'])
        eval(['rmdir(''eeglab_files/'',''s'')'])
    end
end




%%% Aufzählen aller Eventtypes
%%% eeg_eventtypes(EEG)



%%%%%%%%%%%%%%%%%
%%% Parameter %%%
%%%%%%%%%%%%%%%%%


%%% channel selection for loading
all_channels = 1;  %%% 1=yes , 0=no if no, define channel in variable "channel_selection"
channel_selection = [];


%%% Filter
do_filter_data = 1;       %%% 1 = yes 0 = no
lowcutoff= 1;             %%%% in Hz
highcutoff = 50;          %%%% in Hz


%%% Defining bad channel for interpolation visually or by earlier found analysis
interpol_by_eye = 1; %%% 1 = yes 0 = use the channels from saved file


%%% Extracting Epochs
epoch_duration=[-1 4];

epochs(1).trigger = ['S 11'];
epochs(1).name = {'sample_private'};

epochs(2).trigger = ['S 12'];
epochs(2).name = {'sample_public'};

epochs(3).trigger = ['S 21'];
epochs(3).name = {'probe_repetition'};

epochs(4).trigger = ['S 22'];
epochs(4).name = {'probe_lure'};

epochs(5).trigger = ['S 31'];
epochs(5).name = {'sample_ball'};

epochs(6).trigger = ['S 32'];
epochs(6).name = {'sample_no_ball'};

epochs(7).trigger = ['S 41'];
epochs(7).name = {'probe_ball'};

epochs(8).trigger = ['S 42'];
epochs(8).name = {'probe_no_ball'};









%%% Defining bad epochs for rejection visually or by earlier found analysis
rejection_by_eye = 0; %%% 1 = yes 0 = use the channels from saved file

eeglab;

%for sub=1:length(subjects)
sub=1


participant = cell2mat(subjects(sub,1))

clc
eval(['''processing Sub: ',num2str(sub),' from ',num2str(length(subjects)),' - Subject: ',char(subjects(sub,2)),' - Participant: ',num2str(cell2mat(subjects(sub,1))),''''])

%%%%%% create working folder
eval(['mkdir(''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'b/eeglab_files_',char(study_name),''')'])


%%%%%%%%%%%%%%%%%%%%%%
%%%% loading Data %%%%
%%%%%%%%%%%%%%%%%%%%%%


%%%%%% changing channel label for the first 6 subs
%%%%%% muss passieren bevor die ganzen Daten der CHannels mit chanedit
%%%%%% eingetragen werden







if all_channels == 1
    channel_selection=[];
end

eval(['EEG = pop_loadbv(''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'a/'', ''',char(study_name),'_',char(subjects(sub,2)),'a.vhdr'', [] ,[',num2str(channel_selection),']'');'])

eval(['EEG.setname=''A_sub_',num2str(participant),'_raw_data'';']) %%% DATASET Name
EEG = eeg_checkset( EEG );

%%%%%% channels location
EEG=pop_chanedit(EEG, 'lookup','/Work/Programme-Toolboxes/eeglab13_4_4b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp');
EEG = eeg_checkset( EEG );

%%%% Save Raw data
eval(['EEG = pop_saveset( EEG, ''filename'',''A_sub_',num2str(participant),'_raw_data.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'a/eeglab_files_',char(study_name),'/'');'])
EEG = eeg_checkset( EEG );





%%%%%%%%%%%%%%%%%%%%%
%%%% Filter Data %%%%
%%%%%%%%%%%%%%%%%%%%%

if do_filter_data==1

    %%%% Filter Data
    EEG = pop_eegfiltnew(EEG, lowcutoff, highcutoff);
    eval(['EEG.setname=''B_sub_',num2str(participant),'_filter_',num2str(lowcutoff),'_',num2str(highcutoff),'_Hz'';']) %%% DATASET Name
    EEG = eeg_checkset( EEG );

    %%%% Save filtered data
    eval(['EEG = pop_saveset( EEG, ''filename'',''B_sub_',num2str(participant),'_filter_',num2str(lowcutoff),'_',num2str(highcutoff),'_Hz_data.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'a/eeglab_files_',char(study_name),'/'');'])
    EEG = eeg_checkset( EEG );

end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% check for bad channel %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if interpol_by_eye == 1

    pop_eegplot( EEG, 1, 1, 1);

    clc

    how_many_bad_channel = input('How many bad channels: ');

    all_bad_channel=[];
    for rr=1:how_many_bad_channel
        eval(['bad_channel = input(''Name of bad channel ',num2str(rr),': '',''s'');'])
        all_bad_channel=[all_bad_channel; bad_channel];
    end



    interpol_chan=[];
    for hh=1:how_many_bad_channel
        for kk=1:length(EEG.chanlocs)
            if strcmp(EEG.chanlocs(kk).labels,all_bad_channel(hh,:))
                interpol_chan=[interpol_chan;kk];

            end
        end
    end

    eval(['interpol_channel_vpn',num2str(participant),'=interpol_chan;'])



    eval(['save (''',char(home_dir),'/bad_channel_for_interpolating.mat'',''interpol_channel_vpn',num2str(participant),''',''-append'')'])


else

    eval(['load ',char(home_dir),'/bad_channel_for_interpolating'])

end

%%%%%%


eval(['interpol_channel=interpol_channel_vpn',num2str(participant),''])


if isempty(interpol_channel)
    disp('no bad channel!!!')
    eval(['EEG.setname=''C_sub_',num2str(participant),'_after_interpolating'';']) %%% DATASET Name
else
    eval(['EEG = pop_interp(EEG, interpol_channel_vpn',num2str(participant),', ''spherical'');'])
    eval(['EEG.setname=''C_sub_',num2str(participant),'_after_interpolating'';']) %%% DATASET Name
end


%%%% Save cleared data
eval(['EEG = pop_saveset( EEG, ''filename'',''C_sub_',num2str(participant),'_after_interpolating.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'a/eeglab_files_',char(study_name),'/'');'])
EEG = eeg_checkset( EEG );




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% epoching all possible events %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ww=1:length(epochs)
    eval(['trigger(',num2str(ww),')={epochs(',num2str(ww),').trigger};'])
end



EEG = pop_epoch( EEG, trigger , epoch_duration, 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );

eval(['EEG.setname=''D_sub_',num2str(participant),'_after_epoching'';']) %%% DATASET Name

%%%% Save epoched data
eval(['EEG = pop_saveset( EEG, ''filename'',''D_sub_',num2str(participant),'_after_epoching.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'a/eeglab_files_',char(study_name),'/'');'])
EEG = eeg_checkset( EEG );




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%% rejecting bad epochs %%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% if rejection_by_eye == 1
%
%     pop_eegplot( EEG, 1, 1, 0);
%     clc
%     bad_epochs_waiting = input('Hit ENTER after updating bad epochs');
%
%
%     if isempty(ALLEEG)   %%% no bad epochs
%
%         disp('NO BAD EPOCHS!!!')
%         bad_epochs_final=[];
%
%     else
%
%         bad_epochs=ALLEEG(end).reject.rejmanual;
%         bad_epochs_final=find(bad_epochs);
%
%         eval(['bad_epochs_vpn',num2str(participant),'=bad_epochs_final;'])
%         eval(['save (''',char(home_dir),'/bad_epochs_for_rejection.mat'',''bad_epochs_vpn',num2str(participant),''',''-append'')'])
%
%     end
%
% else
%
%     eval(['load ',char(home_dir),'/bad_epochs_for_rejection.mat'])
%     eval(['bad_epochs_final=bad_epochs_vpn',num2str(participant),';'])
%
% end
%
%
% if isempty(bad_epochs_final)
%
%     disp('NO BAD EPOCHS!!!')
%
%     %%%% Save clean  data
%     eval(['EEG.setname=''E_sub_',num2str(participant),'_after_bad_rejecting_epochs'';']) %%% DATASET Name
%     eval(['EEG = pop_saveset( EEG, ''filename'',''E_sub_',num2str(participant),'_after_bad_rejecting_epochs.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'a/eeglab_files_',char(study_name),'/'');'])
%     EEG = eeg_checkset( EEG );
%
% else
%
%     %%%% Save clean  data
%     EEG = pop_rejepoch( EEG, bad_epochs_final ,0);
%     eval(['EEG.setname=''E_sub_',num2str(participant),'_after_bad_rejecting_epochs'';']) %%% DATASET Name
%     eval(['EEG = pop_saveset( EEG, ''filename'',''E_sub_',num2str(participant),'_after_bad_rejecting_epochs.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'a/eeglab_files_',char(study_name),'/'');'])
%     EEG = eeg_checkset( EEG );
%
% end





%end


%%%%%%%%%%%%%%%%%%%%
%%% running ICA %%%%
%%%%%%%%%%%%%%%%%%%%



EEG = pop_runica(EEG, 'extended',1,'interupt','on');
EEG = eeg_checkset( EEG );

%%% save the data with all components
eval(['EEG.setname=''F_sub_',num2str(participant),'_after_ICA_with_all_components'';']) %%% DATASET Name

eval(['EEG = pop_saveset( EEG, ''filename'',''F_sub_',num2str(participant),'_after_ICA_with_all_components.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'a/eeglab_files_',char(study_name),'/'');'])
EEG = eeg_checkset( EEG );


%%% plot ICA components
pop_eegplot( EEG, 0, 1, 1);
pop_topoplot(EEG,0, [1:30] ,'',[6 6] ,0,'electrodes','on');
pop_selectcomps(EEG, [1:30] );

%%% save data sets after discarding the components with "F_1_after_ICA_without_components"

%
%
%
%
%
%
%










%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% 
% 
% 
% close all
% clear
% clc
% 
% home_dir='/Work/Studien/Alondra/EEG_DATA_new';
% study_name='DMS_Training';
% 
% 
% %%%%% subject die im ersten time point genommen wurden!!!!
% 
% subjects={...
%     8,'mqg010';...
%     9,'knk882';...
%     10,'vpg057';...
%     12,'plr729';...
%     13,'fis877';...
%     15,'zye479';...
%     17,'gdu570';...
%     18,'qfw523';...
%     19,'zti042';...
%     21,'stw021';...
%     23,'nmh955';...
%     24,'rgg013';...
%     25,'gld976';...
%     26,'yvq851';...
%     27,'awf230';...
%     28,'zig187';...
%     29,'xdp808';...
%     30,'gqe481';...
%     31,'ogn704';...
%     %32,'pyd907';...
%     33,'nwq680';...
%     34,'tma549';...
%     35,'cze808';...
%     36,'igv205';...
%     37,'gts521';...
%     38,'vpr343';...
%     39,'fct763';...
%     40,'gok669';...
%     41,'qun440';...
%     42,'xrx314';...
%     43,'hcv514';...
%     44,'mfm012';...
%     };
% 
% 
% %%%%%%%%%%%%%%%%%
% %%% Parameter %%%
% %%%%%%%%%%%%%%%%%
% 
% 
% 
% session='b'; %%%%  a = time point 1; b = time point 2
% 
% 
% 
% 
% %%% Extracting Epochs
% epoch_duration=[-1 4];
% 
% epochs(1).trigger = ['S 11'];
% epochs(1).name = {'sample_private'};
% 
% epochs(2).trigger = ['S 12'];
% epochs(2).name = {'sample_public'};
% 
% epochs(3).trigger = ['S 21'];
% epochs(3).name = {'probe_repetition'};
% 
% epochs(4).trigger = ['S 22'];
% epochs(4).name = {'probe_lure'};
% 
% epochs(5).trigger = ['S 31'];
% epochs(5).name = {'sample_ball'};
% 
% epochs(6).trigger = ['S 32'];
% epochs(6).name = {'sample_no_ball'};
% 
% epochs(7).trigger = ['S 41'];
% epochs(7).name = {'probe_ball'};
% 
% epochs(8).trigger = ['S 42'];
% epochs(8).name = {'probe_no_ball'};
% 
% 
% 
% 
% 
% %%% rereference
% do_reref = 1;       %%% 1 = yes 0 = no
% 
% %%% baseline correction
% baseline_corr = [-500 0];
% 
% 
% 
% 
% for sub=3:length(subjects)
% 
% 
% 
% 
% 
% 
% 
% participant = cell2mat(subjects(sub,1))
% 
% eval(['EEG = pop_loadset(''filename'',''F_sub_',num2str(participant),'_after_ICA_without_components.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'',char(session),'/eeglab_files_',char(study_name),'/'');'])
% EEG = eeg_checkset( EEG );
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Re-reference the data %%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% 
% 
% if do_reref == 1    %%% hard coded for rereferencing for the half of the right mastoid
%     
%     
%     EEG = pop_eegchanoperator( EEG, {  ...
%         'nch1 = ch1 - ( (ch22)/2 ) Label Fp1', ...
%         'nch2 = ch2 - ( (ch22)/2 ) Label Fp2', ...
%         'nch3 = ch3 - ( (ch22)/2 ) Label F7', ...
%         'nch4 = ch4 - ( (ch22)/2 ) Label F3', ...
%         'nch5 = ch5 - ( (ch22)/2 ) Label Fz', ...
%         'nch6 = ch6 - ( (ch22)/2 ) Label F4', ...
%         'nch7 = ch7 - ( (ch22)/2 ) Label F8', ...
%         'nch8 = ch8 Label REOG', ...
%         'nch9 = ch9 - ( (ch22)/2 ) Label FC1', ...
%         'nch10 = ch10 - ( (ch22)/2 ) Label FC2', ...
%         'nch11 = ch11 Label LEOG', ...
%         'nch12 = ch12 - ( (ch22)/2 ) Label T7', ...
%         'nch13 = ch13 - ( (ch22)/2 ) Label C3', ...
%         'nch14 = ch14 - ( (ch22)/2 ) Label Cz', ...
%         'nch15 = ch15 - ( (ch22)/2 ) Label C4', ...
%         'nch16 = ch16 - ( (ch22)/2 ) Label T8', ...
%         'nch17 = ch17 Label LVEM', ...
%         'nch18 = ch18 - ( (ch22)/2 ) Label CP5', ...
%         'nch19 = ch19 - ( (ch22)/2 ) Label CP1', ...
%         'nch20 = ch20 - ( (ch22)/2 ) Label CP2', ...
%         'nch21 = ch21 - ( (ch22)/2 ) Label CP6', ...
%         'nch22 = ch22 Label RMAST', ...
%         'nch23 = ch23 - ( (ch22)/2 ) Label P7', ...
%         'nch24 = ch24 - ( (ch22)/2 ) Label P3', ...
%         'nch25 = ch25 - ( (ch22)/2 ) Label Pz', ...
%         'nch26 = ch26 - ( (ch22)/2 ) Label P4', ...
%         'nch27 = ch27 - ( (ch22)/2 ) Label P8', ...
%         'nch28 = ch28 - ( (ch22)/2 ) Label PO9', ...
%         'nch29 = ch29 - ( (ch22)/2 ) Label O1', ...
%         'nch30 = ch30 - ( (ch22)/2 ) Label Oz', ...
%         'nch31 = ch31 - ( (ch22)/2 ) Label O2', ...
%         'nch32 = ch32 - ( (ch22)/2 ) Label PO10' ...
%         } , 'ErrorMsg', 'popup' );
%     EEG = eeg_checkset( EEG );
%     
%     
%     
%     
%     
%     %%%%% channels location
%     EEG=pop_chanedit(EEG, 'lookup','/Work/Programme-Toolboxes/eeglab13_4_4b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp');
%     EEG = eeg_checkset( EEG );
%     
%     eval(['EEG.setname=''G_sub_',num2str(participant),'_after_rereference'';']) %%% DATASET Name
%     eval(['EEG = pop_saveset( EEG, ''filename'',''G_sub_',num2str(participant),'_after_rereference.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'',char(session),'/eeglab_files_',char(study_name),'/'');'])
%     EEG = eeg_checkset( EEG );
%     
%     
% end
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% extracting epochs and rejecting bad epochs %%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% 
% 
% 
% 
% eeglab;
% 
% eval(['EEG = pop_loadset(''filename'',''G_sub_',num2str(participant),'_after_rereference.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'',char(session),'/eeglab_files_',char(study_name),'/'');'])
% EEG = eeg_checkset( EEG );
% 
% 
% 
% 
% %%% ploting signal
% pop_eegplot( EEG, 1, 1, 0);
% 
% bad_epochs_waiting = input('Hit ENTER after updating bad epochs');
% 
% 
% 
% 
% 
% 
% 
% 
% if isempty(ALLEEG)   %%% no bad epochs
%     
%     disp('NO BAD EPOCHS!!!')
%     
%     
%     %%%% Save clean  data
%     eval(['EEG.setname=''G_sub_',num2str(participant),'_without_bad_epochs'';']) %%% DATASET Name
%     eval(['EEG = pop_saveset( EEG, ''filename'',''G_sub_',num2str(participant),'_without_bad_epochs.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'',char(session),'/eeglab_files_',char(study_name),'/'');'])
%     EEG = eeg_checkset( EEG );
%     
%     
%     %%%% save bad epochs in a special file
%     eval(['bad_epochs_sub',num2str(participant),'= 0;'])
%     eval(['save (''',char(home_dir),'/bad_epochs_for_rejection_time_point_2.mat'',''bad_epochs_sub',num2str(participant),''',''-append'')'])
%     
%     
% else
%     
%     bad_epochs=ALLEEG(end).reject.rejmanual;
%     bad_epochs_final=find(bad_epochs);
%     
%     EEG = pop_rejepoch( EEG, bad_epochs_final ,0);
%     
%     
%     
%     %%%% save bad epochs in a special file
%     eval(['bad_epochs_sub',num2str(participant),'= bad_epochs_final;'])
%     eval(['save (''',char(home_dir),'/bad_epochs_for_rejection_time_point_2.mat'',''bad_epochs_sub',num2str(participant),''',''-append'')'])
%     
%     %%%% Save clean  data
%     eval(['EEG.setname=''G_sub_',num2str(participant),'_without_bad_epochs'';']) %%% DATASET Name
%     eval(['EEG = pop_saveset( EEG, ''filename'',''G_sub_',num2str(participant),'_without_bad_epochs.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'',char(session),'/eeglab_files_',char(study_name),'/'');'])
%     EEG = eeg_checkset( EEG );
%     
% end
% 
% 
% 
% 
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% %%% hier werden alle epochiert
% 
% close all
% clear
% clc
% 
% home_dir='/Work/Studien/Alondra/EEG_DATA_new';
% study_name='DMS_Training';
% 
% 
% % subjects={...
% %     8,'mqg010';...
% %     9,'knk882';...
% %     10,'vpg057';...
% %     12,'plr729';...
% %     13,'fis877';...
% %     14,'tkn982';...
% %     15,'zye479';...
% %     16,'uhm826';...
% %     17,'gdu570';...
% %     18,'qfw523';...
% %     19,'zti042';...
% %     21,'stw021';...
% %     23,'nmh955';...
% %     25,'gld976';...
% %     26,'yvq851';...
% %     27,'awf230';...
% %     28,'zig187';...
% %     29,'xdp808';...
% %     30,'gqe481';...
% %     31,'ogn704';...
% %     32,'pyd907';...
% %     33,'nwq680';...
% %     34,'tma549';...
% %     35,'cze808';...
% %     36,'igv205';...
% %     37,'gts521';...
% %     38,'vpr343';...
% %     39,'fct763';...
% %     40,'gok669';...
% %     41,'qun440';...
% %     42,'xrx314';...
% %     43,'hcv514';...
% %     44,'mfm012';...
% %     };
% %
% 
% 
% 
% 
% 
% 
% subjects={...
%     1,'hox956';...
%     2,'vhp563';...
%     3,'zxu637';...
%     4,'hdd890';...
%     6,'pjn299';...
%     7,'vbo819';...
%     8,'mqg010';...
%     9,'knk882';...
%     10,'vpg057';...
%     11,'uzf564';...
%     12,'plr729';...
%     13,'fis877';...
%     14,'tkn982';...
%     15,'zye479';...
%     16,'uhm826';...
%     17,'gdu570';...
%     18,'qfw523';...
%     19,'zti042';...
%     20,'vzk959';...
%     21,'stw021';...
%     22,'vri238';...
%     23,'nmh955';...
%     24,'rgg013';...
%     25,'gld976';...
%     26,'yvq851';...
%     27,'awf230';...
%     28,'zig187';...
%     29,'xdp808';...
%     30,'gqe481';...
%     31,'ogn704';...
%     32,'pyd907';...
%     33,'nwq680';...
%     34,'tma549';...
%     35,'cze808';...
%     36,'igv205';...
%     37,'gts521';...
%     38,'vpr343';...
%     39,'fct763';...
%     40,'gok669';...
%     41,'qun440';...
%     42,'xrx314';...
%     43,'hcv514';...
%     44,'mfm012';...
%     };
% 
% %%%%%%%%%%%%%%%%%
% %%% Parameter %%%
% %%%%%%%%%%%%%%%%%
% 
% 
% %%% Extracting Epochs
% epoch_duration=[-1 4];
% 
% epochs(1).trigger = ['S 11'];
% epochs(1).name = {'sample_private'};
% 
% epochs(2).trigger = ['S 12'];
% epochs(2).name = {'sample_public'};
% 
% epochs(3).trigger = ['S 21'];
% epochs(3).name = {'probe_repetition'};
% 
% epochs(4).trigger = ['S 22'];
% epochs(4).name = {'probe_lure'};
% 
% epochs(5).trigger = ['S 31'];
% epochs(5).name = {'sample_ball'};
% 
% epochs(6).trigger = ['S 32'];
% epochs(6).name = {'sample_no_ball'};
% 
% epochs(7).trigger = ['S 41'];
% epochs(7).name = {'probe_ball'};
% 
% epochs(8).trigger = ['S 42'];
% epochs(8).name = {'probe_no_ball'};
% 
% 
% 
% 
% %%% baseline correction
% baseline_corr = [-500 0];
% 
% %for sub=1:length(subjects)
% 
% 
% 
% 
% sub=23
% 
% 
% 
% 
% participant = cell2mat(subjects(sub,1));
% 
% for gg=1:length(epochs)
%     
%     
%     eval(['EEG = pop_loadset(''filename'',''G_sub_',num2str(participant),'_without_bad_epochs.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'a/eeglab_files_',char(study_name),'/'');'])
%     EEG = eeg_checkset( EEG );
%     
%     
%     eval(['EEG = pop_epoch( EEG, {  ''',char(epochs(gg).trigger),'''  }, epoch_duration, ''newname'', ''G_sub_',num2str(participant),'_cond_',char(cell2mat(epochs(gg).name)),''', ''epochinfo'', ''yes'');'])
%     eval(['EEG = pop_rmbase( EEG, [',num2str(baseline_corr),']);'])
%     
%     %%%% Save epoched data
%     eval(['EEG = pop_saveset( EEG, ''filename'',''H_sub_',num2str(participant),'_cond_',char(cell2mat(epochs(gg).name)),'.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'a/eeglab_files_',char(study_name),'/'');'])
%     EEG = eeg_checkset( EEG );
%     
%     
% end
% 
% %end
% 
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% %%% hier werden alle die hits und misses für lures und repetitons epochiert
% 
% 
% close all
% clear
% clc
% 
% home_dir='/Work/Studien/Alondra/EEG_DATA_new';
% study_name='DMS_Training';
% 
% 
% subjects={...
%     8,'mqg010';...
%     9,'knk882';...
%     10,'vpg057';...
%     12,'plr729';...
%     13,'fis877';...
%     14,'tkn982';...
%     15,'zye479';...
%     16,'uhm826';...
%     17,'gdu570';...
%     18,'qfw523';...
%     19,'zti042';...
%     21,'stw021';...
%     23,'nmh955';...
%     24,'rgg013';...
%     25,'gld976';...
%     26,'yvq851';...
%     27,'awf230';...
%     28,'zig187';...
%     29,'xdp808';...
%     30,'gqe481';...
%     31,'ogn704';...
%     32,'pyd907';...
%     33,'nwq680';...
%     34,'tma549';...
%     35,'cze808';...
%     36,'igv205';...
%     37,'gts521';...
%     38,'vpr343';...
%     39,'fct763';...
%     40,'gok669';...
%     41,'qun440';...
%     42,'xrx314';...
%     43,'hcv514';...
%     44,'mfm012';...
%     };
% 
% 
% %%%%%%%%%%%%%%%%%
% %%% Parameter %%%
% %%%%%%%%%%%%%%%%%
% 
% 
% %%% Extracting Epochs
% epoch_duration=[-1 4];
% 
% 
% 
% epochs(1).trigger = ['S 21'];
% epochs(1).name = {'probe_repetition'};
% 
% epochs(2).trigger = ['S 22'];
% epochs(2).name = {'probe_lure'};
% 
% 
% 
% % %%% Aufzählen aller Eventtypes
% % %%% eeg_eventtypes(EEG)
% %
% 
% 
% %%%% no change 4
% %%%% change 5
% 
% 
% 
% for sub=1:length(subjects)
%     
%     
%     
%     participant = cell2mat(subjects(sub,1));
%     
%     
%     rep_hits=0;
%     rep_false=0;
%     lure_hits=0;
%     lure_false=0;
%     
%     for gg=1:length(epochs)
%         
%         
%         if gg==1
%             
%             eval(['EEG = pop_loadset(''filename'',''H_sub_',num2str(participant),'_cond_',char(cell2mat(epochs(gg).name)),'.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'a/eeglab_files_',char(study_name),'/'');'])
%             EEG = eeg_checkset( EEG );
%             
%             
%             %%%%% repetitions
%             
%             for i =1:length(EEG.event)-1
%                 
%                 if strcmp(EEG.event(i).type, 'S 21') && strcmp(EEG.event(i+1).type, 'S  4') %% --> Rep hit - condition probe_repetition and response from the sub "no change"
%                     EEG.event(i).type = 101;
%                     rep_hits=rep_hits+1;
%                     
%                     
%                 elseif strcmp(EEG.event(i).type, 'S 21') && strcmp(EEG.event(i+1).type, 'S  5') %% --> Rep false alarm - condition probe_repetition and response from the sub "change"
%                     EEG.event(i).type = 102;
%                     rep_false=rep_false+1;
%                     
%                 end
%                 
%             end
%             
%             
%             EEG = eeg_checkset( EEG );
%             
%             eval(['EEG_hit = pop_epoch( EEG, {  ''101''  }, epoch_duration, ''newname'', ''H_sub_',num2str(participant),'_cond_probe_repetition_hit'', ''epochinfo'', ''yes'');'])
%             eval(['EEG_hit = pop_saveset( EEG_hit, ''filename'',''H_sub_',num2str(participant),'_cond_probe_repetition_hit.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'a/eeglab_files_',char(study_name),'/'');'])
%             
%             eval(['EEG_false = pop_epoch( EEG, {  ''102''  }, epoch_duration, ''newname'', ''H_sub_',num2str(participant),'_cond_probe_repetition_false_alarm'', ''epochinfo'', ''yes'');'])
%             eval(['EEG_false = pop_saveset( EEG_false, ''filename'',''H_sub_',num2str(participant),'_cond_probe_repetition_false_alarm.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'a/eeglab_files_',char(study_name),'/'');'])
%             
%             
%             
%             
%             
%             
%         end
%         
%         
%         
%         
%         if gg==2
%             
%             
%             eval(['EEG = pop_loadset(''filename'',''H_sub_',num2str(participant),'_cond_',char(cell2mat(epochs(gg).name)),'.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'a/eeglab_files_',char(study_name),'/'');'])
%             EEG = eeg_checkset( EEG );
%             
%             
%             %%%%% lures
%             
%             for i =1:length(EEG.event)-1
%                 
%                 if strcmp(EEG.event(i).type, 'S 22') && strcmp(EEG.event(i+1).type, 'S  5') %% --> lure hit - condition probe_lure and response from the sub "change"
%                     EEG.event(i).type = 201;
%                     lure_hits=lure_hits+1;
%                     
%                     
%                 elseif strcmp(EEG.event(i).type, 'S 22') && strcmp(EEG.event(i+1).type, 'S  4') %% --> lure false alarm - condition probe_lure and response from the sub "no change"
%                     EEG.event(i).type = 202;
%                     lure_false=lure_false+1;
%                     
%                 end
%                 
%             end
%             
%             
%             
%             EEG = eeg_checkset( EEG );
%             
%             eval(['EEG_hit = pop_epoch( EEG, {  ''201''  }, epoch_duration, ''newname'', ''H_sub_',num2str(participant),'_cond_probe_lure_hit'', ''epochinfo'', ''yes'');'])
%             eval(['EEG_hit = pop_saveset( EEG_hit, ''filename'',''H_sub_',num2str(participant),'_cond_probe_lure_hit.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'a/eeglab_files_',char(study_name),'/'');'])
%             
%             eval(['EEG_false = pop_epoch( EEG, {  ''202''  }, epoch_duration, ''newname'', ''H_sub_',num2str(participant),'_cond_probe_lure_false_alarm'', ''epochinfo'', ''yes'');'])
%             eval(['EEG_false = pop_saveset( EEG_false, ''filename'',''H_sub_',num2str(participant),'_cond_probe_lure_false_alarm.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'a/eeglab_files_',char(study_name),'/'');'])
%             
%             
%             
%         end
%         
%     end
%     
%     
%     eval(['	proportion_hit_false_alarm_sub_',num2str(participant),'=[rep_hits rep_false lure_hits lure_false];'])
%     eval(['save (''',char(home_dir),'/proportion_hit_false_alarm.mat'',''proportion_hit_false_alarm_sub_',num2str(participant),''',''-append'')'])
%     
%     
%     
%     
% end
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
