% Preprocessing took place with GUI and with the use of this script. 

close all
clear
clc
home_dir='/Users/alondra/Documents/MATLAB/DMS/';
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
    32,'pjd907';...
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

% Our steps for preprocessing included: 
% 0) channel location
% 1) Filter
% 2) interpolate bad channels
% 3) epoching for all possible events
% 4) Artifact rejection (statistical thresholds and/or visual inspection)
% 5) Artifact correction (regression, PCA, ICA)
% 6) re-reference  (LMST, Nix, half LMAST)
% 7) Baseline correction

delete_all=0;
if delete_all==1

    %%% alle eeglab folder l?schen
    for sub=1:length(subjects)

        eval(['cd (''',char(home_dir),'/vpn',num2str(subjects(sub)),''')'])
        eval(['rmdir(''eeglab_files/'',''s'')'])
    end

end

 
%%% Aufz?hlen aller Eventtypes

%%% eeg_eventtypes(EEG)

%%%%%%%%%%%%%%%%%
%%% Parameter %%%
%%%%%%%%%%%%%%%%%

%%% 0. channel selection for loading

all_channels = 1;  %%% 1=yes , 0=no if no, define channel in variable "channel_selection"
channel_selection = [];

 
%%% Filter parameters

do_filter_data = 1;       %%% 1 = yes 0 = no
lowcutoff= 1;             %%%% in Hz
highcutoff = 50;          %%%% in Hz

%%% Defining bad channel for interpolation visually or by earlier found analysis

interpol_by_eye = 1; %%% 1 = yes 0 = use the channels from saved file

%%% Extracting Epochs

epoch_duration=[-1 12];
 
epochs(1).trigger = ['S 11'];
epochs(1).name = {'sample_private'};

epochs(2).trigger = ['S 12'];
epochs(2).name = {'sample_public'};

%epochs(3).trigger = ['S 21'];
%epochs(3).name = {'probe_repetition'};

%epochs(4).trigger = ['S 22'];
%epochs(4).name = {'probe_lure'};

epochs(5).trigger = ['S 31'];
epochs(5).name = {'sample_ball'};

epochs(6).trigger = ['S 32'];
epochs(6).name = {'sample_no_ball'};
 
%epochs(7).trigger = ['S 41'];
%epochs(7).name = {'probe_ball'};
 
%epochs(8).trigger = ['S 42'];
%epochs(8).name = {'probe_no_ball'};
 
%%% Defining bad epochs for rejection visually or by earlier found analysis

rejection_by_eye = 0; %%% 1 = yes 0 = use the channels from saved file 

eeglab;

% Start preprocessing either by looping or going one subject at a time

%for sub = 7:length(subjects) % preprocess several subjects at a time 
sub=1; % preprocess one subject at a time

participant = cell2mat(subjects(sub,1));
clc

eval(['''processing Sub: ',num2str(sub),' from ',num2str(length(subjects)),' - Subject: ',char(subjects(sub,2)),' - Participant: ',num2str(cell2mat(subjects(sub,1))),''''])
 
%%%%%% create working folder

eval(['mkdir(''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'a/eeglab_files_',char(study_name),''')'])

%%%%%%%%%%%%%%%%%%%%%%
%%%% load Data %%%%
%%%%%%%%%%%%%%%%%%%%%%

if all_channels == 1

    channel_selection=[];

end


eval(['EEG = pop_loadbv(''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'a/'', ''',char(study_name),'_',char(subjects(sub,2)),'a.vhdr'', [] ,[',num2str(channel_selection),']'');'])
eval(['EEG.setname=''A_sub_',num2str(participant),'_raw_data'';']) %%% DATASET Name

EEG = eeg_checkset( EEG );

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% channels location %
%%%%%%%%%%%%%%%%%%%%%%%%%%

EEG=pop_chanedit(EEG, 'lookup','Users/alondra/Documents/MATLAB/eeglab13_4_4b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp');

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
%%%% Channel interpolation %%%%
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
%%%% Epoching all possible events %%%%
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
% %%%% Rejecting bad epochs %%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if rejection_by_eye == 1

    pop_eegplot( EEG, 1, 1, 0);

    clc

    bad_epochs_waiting = input('Hit ENTER after updating bad epochs');

    if isempty(ALLEEG)   %%% no bad epochs

        disp('NO BAD EPOCHS!!!')

        bad_epochs_final=[];
        
    else

        bad_epochs=ALLEEG(end).reject.rejmanual;

        bad_epochs_final=find(bad_epochs);

        eval(['bad_epochs_vpn',num2str(participant),'=bad_epochs_final;'])

        eval(['save (''',char(home_dir),'/bad_epochs_for_rejection.mat'',''bad_epochs_vpn',num2str(participant),''',''-append'')'])

    end

else

    eval(['load ',char(home_dir),'/bad_epochs_for_rejection.mat'])

    eval(['bad_epochs_final=bad_epochs_vpn',num2str(participant),';'])

end

if isempty(bad_epochs_final)

    disp('NO BAD EPOCHS!!!')

    %%%% Save clean  data

    eval(['EEG.setname=''E_sub_',num2str(participant),'_after_bad_rejecting_epochs'';']) %%% DATASET Name

    eval(['EEG = pop_saveset( EEG, ''filename'',''E_sub_',num2str(participant),'_after_bad_rejecting_epochs.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'a/eeglab_files_',char(study_name),'/'');'])

    EEG = eeg_checkset( EEG );

end

%%%%%%%%%%%%%%%%%%%$
%%$ running ICA %%%%
%%%%%%%%%%%%%%%%%%%$

EEG = pop_runica(EEG, 'extended',1,'interupt','on');

EEG = eeg_checkset( EEG );
 

%% save the data with all components

eval(['EEG.setname=''F_sub_',num2str(participant),'_after_ICA_with_all_components'';']) %%% DATASET Name

eval(['EEG = pop_saveset( EEG, ''filename'',''F_sub_',num2str(participant),'_after_ICA_with_all_components.set'',''filepath'',''',char(home_dir),'/sub_',num2str(participant),'_',char(subjects(sub,2)),'a/eeglab_files_',char(study_name),'/'');'])

EEG = eeg_checkset( EEG );

%% plot ICA components

pop_eegplot( EEG, 0, 1, 1);

pop_topoplot(EEG,0, [1:30] ,'',[6 6] ,0,'electrodes','on');

pop_selectcomps(EEG, [1:30] );


%% save data sets after discarding the components with "F_1_after_ICA_without_components"
%%%%%%%%%%%%%%%%%%%%%%
%%% Re-referencing %%%
%%%%%%%%%%%%%%%%%%%%%%

do_reref = 0;       %%% 1 = yes 0 = no
reref_channel = 'average'; %%% name of channel for Re-referencing; use 'average' for re-reference over the average of all channels; 'LMAST' for re-reference against the left Mastoid; or the name of any other channel
%reref_channel = 'LMAST';

%%% baseline correction
baseline_corr = [-500 0];

%for sub=1:length(subjects)
sub=1;

eval(['EEG = pop_loadset(''filename'',''F_',num2str(subjects(sub)),'_after_ICA_without_components.set'',''filepath'',''',char(home_dir),'/vpn',num2str(subjects(sub)),'/eeglab_files/'');'])

EEG = eeg_checkset( EEG );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Re-reference the data %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Extracting epochs and rejecting bad epochs %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for gg=1:length(epochs)
    
    eeglab;
    
    if do_reref == 0

        eval(['EEG = pop_loadset(''filename'',''H_',num2str(subjects(sub)),'_no_reref_BC.set'',''filepath'',''',char(home_dir),'/vpn',num2str(subjects(sub)),'/eeglab_files/'');'])

        EEG = eeg_checkset( EEG );
        
    elseif do_reref == 1
        
        eval(['EEG = pop_loadset(''filename'',''H_',num2str(subjects(sub)),'_reref_to_',char(reref_channel),'_BC.set'',''filepath'',''',char(home_dir),'/vpn',num2str(subjects(sub)),'/eeglab_files/'');'])

        EEG = eeg_checkset( EEG );

    end
    
    eval(['EEG = pop_epoch( EEG, {  ''',char(epochs(gg).trigger),'''  }, epoch_duration, ''newname'', ''I_',num2str(subjects(sub)),'_reref_to_',char(reref_channel),'_',char(cell2mat(epochs(gg).name)),''', ''epochinfo'', ''yes'');'])
    

    %%% ploting signal

    pop_eegplot( EEG, 1, 1, 0);

    clc

    bad_epochs_waiting = input('Hit ENTER after updating bad epochs');
        
    if isempty(ALLEEG)   %%% no bad epochs
        
        disp('NO BAD EPOCHS!!!')
        
        
        if do_reref == 0

            %%%% Save clean  data

            eval(['EEG = pop_saveset( EEG, ''filename'',''I_',num2str(subjects(sub)),'_no_reref_',char(cell2mat(epochs(gg).name)),'.set'',''filepath'',''',char(home_dir),'/vpn',num2str(subjects(sub)),'/eeglab_files/'');'])

            EEG = eeg_checkset( EEG );

        elseif do_reref == 1

            %%%% Save clean  data

            eval(['EEG = pop_saveset( EEG, ''filename'',''I_',num2str(subjects(sub)),'_reref_to_',char(reref_channel),'_',char(cell2mat(epochs(gg).name)),'.set'',''filepath'',''',char(home_dir),'/vpn',num2str(subjects(sub)),'/eeglab_files/'');'])

            EEG = eeg_checkset( EEG );
            
        end
        
    else
        
        bad_epochs=ALLEEG(end).reject.rejmanual;

        bad_epochs_final=find(bad_epochs);        

        EEG = pop_rejepoch( EEG, bad_epochs_final ,0);
    
        if do_reref == 0

            %%%% Save clean  data

            eval(['EEG = pop_saveset( EEG, ''filename'',''I_',num2str(subjects(sub)),'_no_reref_',char(cell2mat(epochs(gg).name)),'.set'',''filepath'',''',char(home_dir),'/vpn',num2str(subjects(sub)),'/eeglab_files/'');'])

            EEG = eeg_checkset( EEG );

        elseif do_reref == 1

            eval(['EEG = pop_saveset( EEG, ''filename'',''I_',num2str(subjects(sub)),'_reref_to_',char(reref_channel),'_',char(cell2mat(epochs(gg).name)),'.set'',''filepath'',''',char(home_dir),'/vpn',num2str(subjects(sub)),'/eeglab_files/'');'])

            EEG = eeg_checkset( EEG );
            
        end

    end

end

%end



