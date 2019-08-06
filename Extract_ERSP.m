% loading variables. For individual loads: load ersp_exptask_control_tp1.mat;
% 
% tp='tp2';
% task='exptask';
% % group='trainees';
% 
% filename=(['ersp5_3to20Hz_' task '_' tp '.mat']);
% var_f=(['ersp5_' task '_' tp]);
% 
% filename=(['ersp5_3to20Hz_' task '_' tp '.mat']);
% % var_f=(['ersp6_2to20Hz_' task '_' tp]);
% load(filename)
% 
% %defining temporary variable, as data of interest
% eval(['temp=' var_f ';']);

%Obtain ERSP values for all the channels
chanlocs = eeg_mergelocs(ALLEEG.chanlocs);  %merges the ERSP values from all subjects for each of the 31 channel 
[STUDY, ersp, times, freqs] = std_erspplot(STUDY,ALLEEG, 'channels',{ chanlocs.labels }, 'ersplim', [-3 3]);

% temp=ersp{2}; %experimental task
temp=ersp{1}; %non-experimental task

% Trimming matrix for all channels and all subjects
% temp2=temp(44:69,74:127,:,:);    %alpha band, modified delay phase

temp2=temp(28:45,83:128,:,:);   
%loop for ersp{1}, control group for time point one 
result=zeros(size(temp2,3), size(temp2,4));
for cha = 1:size(temp2,3);   %form channel 1 to 31, all channels
    for subj = 1:size(temp2,4);   %for subject 1 to 21 (14 for trainees), all subjects
        result(cha,subj) = mean(reshape(temp2(:,:,cha,subj),[1 size(temp2,1)*size(temp2,2)])); %reshape(matrix,[1 rows*columns]) <--This creates a vector on which "mean" can now work on.
    end
 end

temp3=temp(1:9,150:159,:,:);   
%loop for ersp{1}, control group for time point one 
result3=zeros(size(temp3,3), size(temp3,4));
for cha = 1:size(temp3,3);   %form channel 1 to 31, all channels
    for subj = 1:size(temp3,4);   %for subject 1 to 21 (14 for trainees), all subjects
        result3(cha,subj) = mean(reshape(temp3(:,:,cha,subj),[1 size(temp3,1)*size(temp3,2)])); %reshape(matrix,[1 rows*columns]) <--This creates a vector on which "mean" can now work on.
    end
 end
temp4=temp(10:22,83:128,:,:);   
%loop for ersp{1}, control group for time point one 
result4=zeros(size(temp4,3), size(temp4,4));
for cha = 1:size(temp4,3);   %form channel 1 to 31, all channels
    for subj = 1:size(temp4,4);   %for subject 1 to 21 (14 for trainees), all subjects
        result4(cha,subj) = mean(reshape(temp4(:,:,cha,subj),[1 size(temp4,1)*size(temp4,2)])); %reshape(matrix,[1 rows*columns]) <--This creates a vector on which "mean" can now work on.
    end
 end
temp5=temp(23:32,83:128,:,:);   
%loop for ersp{1}, control group for time point one 
result5=zeros(size(temp5,3), size(temp5,4));
for cha = 1:size(temp5,3);   %form channel 1 to 31, all channels
    for subj = 1:size(temp5,4);   %for subject 1 to 21 (14 for trainees), all subjects
        result5(cha,subj) = mean(reshape(temp5(:,:,cha,subj),[1 size(temp5,1)*size(temp5,2)])); %reshape(matrix,[1 rows*columns]) <--This creates a vector on which "mean" can now work on.
    end
 end
temp6=temp(33:41,150:159,:,:);   
%loop for ersp{1}, control group for time point one 
result6=zeros(size(temp6,3), size(temp6,4));
for cha = 1:size(temp6,3);   %form channel 1 to 31, all channels
    for subj = 1:size(temp6,4);   %for subject 1 to 21 (14 for trainees), all subjects
        result6(cha,subj) = mean(reshape(temp6(:,:,cha,subj),[1 size(temp6,1)*size(temp6,2)])); %reshape(matrix,[1 rows*columns]) <--This creates a vector on which "mean" can now work on.
    end
 end
temp7=temp(42:49,146:163,:,:);   
%loop for ersp{1}, control group for time point one 
result7=zeros(size(temp7,3), size(temp7,4));
for cha = 1:size(temp7,3);   %form channel 1 to 31, all channels
    for subj = 1:size(temp7,4);   %for subject 1 to 21 (14 for trainees), all subjects
        result7(cha,subj) = mean(reshape(temp7(:,:,cha,subj),[1 size(temp7,1)*size(temp7,2)])); %reshape(matrix,[1 rows*columns]) <--This creates a vector on which "mean" can now work on.
    end
end

temp8=temp(50:55,83:128,:,:);
%loop for ersp{1}, control group for time point one 
result8=zeros(size(temp8,3), size(temp8,4));
for cha = 1:size(temp8,3);   %form channel 1 to 31, all channels
    for subj = 1:size(temp8,4);   %for subject 1 to 21 (14 for trainees), all subjects
        result8(cha,subj) = mean(reshape(temp8(:,:,cha,subj),[1 size(temp8,1)*size(temp8,2)])); %reshape(matrix,[1 rows*columns]) <--This creates a vector on which "mean" can now work on.
    end
 end

temp9=temp(56:61,83:128,:,:);   
%loop for ersp{1}, control group for time point one 
result9=zeros(size(temp9,3), size(temp9,4));
for cha = 1:size(temp9,3);   %form channel 1 to 31, all channels
    for subj = 1:size(temp9,4);   %for subject 1 to 21 (14 for trainees), all subjects
        result9(cha,subj) = mean(reshape(temp9(:,:,cha,subj),[1 size(temp9,1)*size(temp9,2)])); %reshape(matrix,[1 rows*columns]) <--This creates a vector on which "mean" can now work on.
    end
 end
temp10=temp(62:66,146:163,:,:);   
%loop for ersp{1}, control group for time point one 
result10=zeros(size(temp10,3), size(temp10,4));
for cha = 1:size(temp10,3);   %form channel 1 to 31, all channels
    for subj = 1:size(temp10,4);   %for subject 1 to 21 (14 for trainees), all subjects
        result10(cha,subj) = mean(reshape(temp10(:,:,cha,subj),[1 size(temp10,1)*size(temp10,2)])); %reshape(matrix,[1 rows*columns]) <--This creates a vector on which "mean" can now work on.
    end
 end
temp11=temp(67:71,146:163,:,:);   
%loop for ersp{1}, control group for time point one 
result11=zeros(size(temp11,3), size(temp11,4));
for cha = 1:size(temp11,3);   %form channel 1 to 31, all channels
    for subj = 1:size(temp11,4);   %for subject 1 to 21 (14 for trainees), all subjects
        result11(cha,subj) = mean(reshape(temp11(:,:,cha,subj),[1 size(temp11,1)*size(temp11,2)])); %reshape(matrix,[1 rows*columns]) <--This creates a vector on which "mean" can now work on.
    end
 end
temp12=temp(72:75,146:163,:,:);   
%loop for ersp{1}, control group for time point one 
result12=zeros(size(temp12,3), size(temp12,4));
for cha = 1:size(temp12,3);   %form channel 1 to 31, all channels
    for subj = 1:size(temp12,4);   %for subject 1 to 21 (14 for trainees), all subjects
        result12(cha,subj) = mean(reshape(temp12(:,:,cha,subj),[1 size(temp12,1)*size(temp12,2)])); %reshape(matrix,[1 rows*columns]) <--This creates a vector on which "mean" can now work on.
    end
 end
temp13=temp(76:79,83:128,:,:);   
%loop for ersp{1}, control group for time point one 
result13=zeros(size(temp13,3), size(temp13,4));
for cha = 1:size(temp13,3);   %form channel 1 to 31, all channels
    for subj = 1:size(temp13,4);   %for subject 1 to 21 (14 for trainees), all subjects
        result13(cha,subj) = mean(reshape(temp13(:,:,cha,subj),[1 size(temp13,1)*size(temp13,2)])); %reshape(matrix,[1 rows*columns]) <--This creates a vector on which "mean" can now work on.
    end
end

temp14=temp(80:83,83:128,:,:);
%loop for ersp{1}, control group for time point one 
result14=zeros(size(temp14,3), size(temp14,4));
for cha = 1:size(temp14,3);   %form channel 1 to 31, all channels
    for subj = 1:size(temp14,4);   %for subject 1 to 21 (14 for trainees), all subjects
        result14(cha,subj) = mean(reshape(temp14(:,:,cha,subj),[1 size(temp14,1)*size(temp14,2)])); %reshape(matrix,[1 rows*columns]) <--This creates a vector on which "mean" can now work on.
    end
 end

% a = result';  %Transpose to get the mean for the channels (since they are rows)
% avg = mean(a);    %Will average the values for all subjects for each channel 
% avgtranspose=avg';
% 
% figure;
% imagesc (result);
% colormap(jet(256));

% file=mean(a);
% array=temp2;
% xlswrite (filename.xls, '[:,:,:,:]')

% % 
