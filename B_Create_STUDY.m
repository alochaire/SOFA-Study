clear
close all

%%% studie directory

%home_dir='/Work/Studien/Alondra/EEG_DATA_new';
home_dir='/Users/alondra/Documents/MATLAB/DMS';
home_dir2='/Users/alondra/Documents/MATLAB/DMS/Timeptwo';
study_name='DMS_Training_Study';

folder_name='Tpt1_and_Tpt2';
% 
% eval(['mkdir /Work/Studien/Alondra/EEG_DATA_new/STUDY_GrandAverage/',char(folder_name),''])
% eval(['cd /Work/Studien/Alondra/EEG_DATA_new/STUDY_GrandAverage/',char(folder_name),''])

eval(['mkdir /Users/alondra/Documents/MATLAB/DMS/',char(folder_name),''])
eval(['cd /Users/alondra/Documents/MATLAB/DMS/',char(folder_name),''])
 
%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
%  
subjects{1}.name='hox956'         
subjects{1}.group='training'

subjects{2}.name='vhp563'
subjects{2}.group='training'
% 
% % subjects{3}.name='zxu637'       % rausgeflogen zu wenig trials in EEG Aber verhaltensdaten sehen gut aus !!!!
% % subjects{3}.group='training'
% 
subjects{4}.name='hdd890'
subjects{4}.group='training'

subjects{6}.name='pjn299'         % Only 4 runs (3 x reps & lures; 1 x ball & no ball) BUT its OK
subjects{6}.group='training'

subjects{7}.name='vbo819'
subjects{7}.group='training'

subjects{8}.name='mqg010'
subjects{8}.group='control'

subjects{9}.name='knk882'        
subjects{9}.group='training'

subjects{10}.name='vpg057'
subjects{10}.group='control'       

% % subjects{11}.name='uzf564'      No trigger send!!!
% % subjects{11}.group='control'

subjects{12}.name='plr729'
subjects{12}.group='training'

subjects{13}.name='fis877'
subjects{13}.group='control'

% subjects{14}.name='tkn982'      
% subjects{14}.group='training'

subjects{15}.name='zye479'
subjects{15}.group='training'

 

subjects{16}.name='uhm826'       
subjects{16}.group='training'

subjects{17}.name='gdu570'       %Missing one condition (ball_incorrect)
subjects{17}.group='control'

subjects{18}.name='qfw523'
subjects{18}.group='training'

subjects{19}.name='zti042'      
subjects{19}.group='control'


subjects{20}.name='vzk959'
subjects{20}.group='control'

subjects{21}.name='stw021'
subjects{21}.group='training'

subjects{22}.name='vri238'       
subjects{22}.group='training'

subjects{23}.name='nmh955'
subjects{23}.group='control'

subjects{24}.name='rgg013'
subjects{24}.group='training'

subjects{25}.name='gld976'
subjects{25}.group='control'

subjects{26}.name='yvq851'
subjects{26}.group='control'

subjects{27}.name='awf230'
subjects{27}.group='training'

subjects{28}.name='zig187'
subjects{28}.group='training'

subjects{29}.name='xdp808'
subjects{29}.group='control'

subjects{30}.name='gqe481'
subjects{30}.group='control'

subjects{31}.name='ogn704'
subjects{31}.group='training'

subjects{32}.name='pjd907'         
subjects{32}.group='control'

subjects{33}.name='nwq680'
subjects{33}.group='control'

subjects{34}.name='tma549'
subjects{34}.group='control'

subjects{35}.name='cze808'
subjects{35}.group='control'


subjects{36}.name='igv205'
subjects{36}.group='training'            %He is a trainee

subjects{37}.name='gts521'
subjects{37}.group='control'

subjects{38}.name='vpr343'
subjects{38}.group='control'

subjects{39}.name='fct763'
subjects{39}.group='control'

subjects{40}.name='gok669'
subjects{40}.group='control'

subjects{41}.name='qun440'
subjects{41}.group='control'

subjects{42}.name='xrx314'
subjects{42}.group='control'

subjects{43}.name='hcv514'
subjects{43}.group='training'

subjects{44}.name='mfm012'
subjects{44}.group='control'


conditions{1} = 'ball_correct'          %Epochs conditions for the first time point in my study
conditions{2} = 'ball_incorrect'
conditions{3} = 'lure_correct_rej'
conditions{4} = 'lure_false_alarm'
conditions{5} = 'rep_hit'
conditions{6} = 'rep_miss'

conditions{7} = 'ball_correct'          %Same epochs conditions for the second time point
conditions{8} = 'ball_incorrect'
conditions{9} = 'lure_correct_rej'
conditions{10} = 'lure_false_alarm'
conditions{11} = 'rep_hit'
conditions{12} = 'rep_miss'

cnt_index=1;

for i=1:length(subjects)
        
    if isempty(subjects{i})     %%% if subject empty
        
        disp('')
        
    else        
        
        subj_nr=i;
        
        subname=subjects{i}.name;
        
        group=subjects{i}.group;
        
        
        for k=1:length(conditions)
            
            
            if k<=6
                
                time_point='a'
                
                
                eval(['matrix{cnt_index}= {''index'' ',num2str(cnt_index),' ''load'' ''',char(home_dir),'/sub_',num2str(i),'_',char(subname),'',char(time_point),'/eeglab_files_DMS_Training/I_sub_',num2str(i),'_sample_',char(conditions(k)),'.set'' ''subject'' ''',num2str(i),''' ''condition'' ''',char(conditions(k)),'_tpt_1'' ''group'' ''',char(group),'''} '])
                
                cnt_index=cnt_index+1;
                
            elseif k>6
                
                time_point='b'
                
                
                eval(['matrix{cnt_index}= {''index'' ',num2str(cnt_index),' ''load'' ''',char(home_dir2),'/sub_',num2str(i),'_',char(subname),'',char(time_point),'/eeglab_files_DMS_Training/I_sub_',num2str(i),'_sample_',char(conditions(k)),'.set'' ''subject'' ''',num2str(i),''' ''condition'' ''',char(conditions(k)),'_tpt_2'' ''group'' ''',char(group),'''} '])
                
                cnt_index=cnt_index+1;
                
                
            end
            
        end
        
    end
    
    
end


[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

eval(['[STUDY ALLEEG] = std_editset( STUDY, ALLEEG, ''name'',''',char(folder_name),''',''commands'',matrix,''updatedat'',''on'' );'])

[STUDY ALLEEG] = std_checkset(STUDY, ALLEEG);

eval(['[STUDY EEG] = pop_savestudy( STUDY, EEG, ''filename'',''',char(folder_name),'.study'',''filepath'',''/Users/alondra/Documents/MATLAB/DMS/',char(folder_name),''');'])

CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
