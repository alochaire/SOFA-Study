
%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
clc
%addpath(genpath('c:/alondra'))
%home_dir='c:/alondra/experiment';
%home_dir='d:/arbeit/alondra/experiment';
home_dir='/Users/alondra/Documents/MATLAB/DMS/Behavioral_data';

cd(home_dir);
%%%%%%%%%%%%%%%%%%%%%%%%%
%subj_name = input('enter subjects id: ','s');

subject_name = {'plr729b';'nwq680b'}; 
%%%%%%%%%%%%%%%%%%%%%%%%%
%{'hox956b'; 'vbo819b'; 'uzf564b'; 'vhp563b'; 'hdd890b'; 'pjn299b'; 'vbo819b'; 'mqg010b'; 'knk882b'; 'vpg057b'; 'uzf564b';
 %   'plr729b'; 'tkn982b'; 'zye479b'; 'uhm826b'; 'gdu570b'; 'qfw523b'; 'zti042b'; 'stw021b'; 'qun440b'; 'yvq851b'; 'xdp808b'; 
  %  'gqe481b'; 'pjd907b'; 'tma549b'; 'cze808b'; 'igv205b'; 'gts521b'; 'vpr343b'; 'fct763b'; 'awf230b';
   % 'nwq680b'; 'xrx314b'; 'hcv514b'; 'mfm012b'};

average_rep_lure=[];
average_ball=[];
average_privare_public=[];


for uu=1:length(subject_name)
    
    subj_name=subject_name(uu)
    
    rep_task_all=0;
    ball_task_all=0;
    
    for i=1:6  %%% runs
        eval(['load subj_',char(subj_name),'/result_subj_',char(subj_name),'_run_',num2str(i),'_session_2','.mat'])
        eval(['[a b]=size(result_subj_',char(subj_name),'_run_',num2str(i),'{1});'])
        if b==9   %%% lure rep Task
            rep_task_all=rep_task_all+1;
            eval(['rep_task{',num2str(rep_task_all),'}=result_subj_',char(subj_name),'_run_',num2str(i),';'])
        elseif b==10 %%% ball Task
            ball_task_all=ball_task_all+1;
            eval(['ball_task{',num2str(ball_task_all),'}=result_subj_',char(subj_name),'_run_',num2str(i),';'])
        end
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% lure_rep_task %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    public=[];
    private=[];
    rep=[];
    lure=[];
    
    for i=1:length(rep_task)
        eval(['run_rep=rep_task{',num2str(i),'}'])
        for j=1:length(run_rep)
            if strcmp(run_rep{j}(2),'public')
                public=[public; cell2mat(run_rep{j}(5))-cell2mat(run_rep{j}(3)) cell2mat(run_rep{j}(4))]
            elseif strcmp(run_rep{j}(2),'private')
                private=[private; cell2mat(run_rep{j}(5))-cell2mat(run_rep{j}(3)) cell2mat(run_rep{j}(4))]
            end
            
            if strcmp(run_rep{j}(6),'reps')
                rep=[rep; cell2mat(run_rep{j}(9))-cell2mat(run_rep{j}(7)) cell2mat(run_rep{j}(8))]
            elseif strcmp(run_rep{j}(6),'lure')
                lure=[lure; cell2mat(run_rep{j}(9))-cell2mat(run_rep{j}(7)) cell2mat(run_rep{j}(8))]
            end
            
        end
    end
    
    %%%% private vs. public %%%%%
    
    public_correct=[];
    public_uncorrect=[];
    public_no_resp=[];
    
    private_correct=[];
    private_uncorrect=[];
    private_no_resp=[];
    
    for i=1:length(public)
        if public(i,2)==5 %%% correct
            public_correct=[public_correct public(i,1)];
        elseif public(i,2)==4 %%% uncorrect
            public_uncorrect=[public_uncorrect public(i,1)];
        elseif public(i,2)==0 %%% no resp
            public_no_resp=[public_no_resp 0];
        end
    end
    
    for i=1:length(private)
        if private(i,2)==4 %%% correct
            private_correct=[private_correct private(i,1)];
        elseif private(i,2)==5 %%% uncorrect
            private_uncorrect=[private_uncorrect private(i,1)];
        elseif private(i,2)==0 %%% no resp
            private_no_resp=[private_no_resp 0];
        end
    end
    
    hitrate_public=[length(public_correct)/length(public) length(public_uncorrect)/length(public) length(public_no_resp)/length(public)];
    hitrate_private=[length(private_correct)/length(private) length(private_uncorrect)/length(private) length(private_no_resp)/length(private)];
    
    RT_public=[mean(public_correct) mean(public_uncorrect)];
    RT_private=[mean(private_correct) mean(private_uncorrect)];
    

    %%%% lures vs. reps %%%%%
    
    rep_correct=[];
    rep_uncorrect=[];
    rep_no_resp=[];
    
    lures_correct=[];
    lures_uncorrect=[];
    lures_no_resp=[];
    
    for i=1:length(rep)
        if rep(i,2)==4 %%% correct
            rep_correct=[rep_correct rep(i,1)];
        elseif rep(i,2)==5 %%% uncorrect
            rep_uncorrect=[rep_uncorrect rep(i,1)];
        elseif rep(i,2)==0 %%% no resp
            rep_no_resp=[rep_no_resp 0];
        end
    end
    
    for i=1:length(lure)
        if lure(i,2)==5 %%% correct
            lures_correct=[lures_correct lure(i,1)];
        elseif lure(i,2)==4 %%% uncorrect
            lures_uncorrect=[lures_uncorrect lure(i,1)];
        elseif lure(i,2)==0 %%% no resp
            lures_no_resp=[lures_no_resp 0];
        end
    end
    
    hitrate_rep=[length(rep_correct)/length(rep) length(rep_uncorrect)/length(rep) length(rep_no_resp)/length(rep)];
    hitrate_lures=[length(lures_correct)/length(lure) length(lures_uncorrect)/length(lure) length(lures_no_resp)/length(lure)];
    
    RT_rep=[mean(rep_correct) mean(rep_uncorrect)];
    RT_lures=[mean(lures_correct) mean(lures_uncorrect)];
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% ball - task %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    sample_correct=[];
    sample_uncorrect=[];
    sample_no_resp=[];
    
    probe_correct=[];
    probe_uncorrect=[];
    probe_no_resp=[];
    
    
    for i=1:length(ball_task)
        eval(['run_ball=ball_task{',num2str(i),'};'])
        for j=1:length(run_ball)
            
            %%%% sample correct
            if strcmp(run_ball{j}(2),'   ball') && cell2mat(run_ball{j}(4))==4 %%% yes I see the ball - button
                sample_correct=[sample_correct; cell2mat(run_ball{j}(5))-cell2mat(run_ball{j}(3))]
            elseif strcmp(run_ball{j}(2),'no_ball') && cell2mat(run_ball{j}(4))==5 %%% no I see no ball - button
                sample_correct=[sample_correct; cell2mat(run_ball{j}(5))-cell2mat(run_ball{j}(3))]
                
                %%%% sample uncorrect
            elseif strcmp(run_ball{j}(2),'   ball') && cell2mat(run_ball{j}(4))==5 %%% no I see no ball - but the ball was there
                sample_uncorrect=[sample_uncorrect; cell2mat(run_ball{j}(5))-cell2mat(run_ball{j}(3))]
            elseif strcmp(run_ball{j}(2),'no_ball') && cell2mat(run_ball{j}(4))==4 %%% yes I see the ball - but there was no ball
                sample_uncorrect=[sample_uncorrect; cell2mat(run_ball{j}(5))-cell2mat(run_ball{j}(3))]
                
                %%% sample no resp
            elseif cell2mat(run_ball{j}(4))==0
                sample_no_resp=[sample_no_resp; 0];
                
            end
        end
    end
    
    length_ball_task=0;
    
    
    for i=1:length(ball_task)
        eval(['run_ball=ball_task{',num2str(i),'};'])
        for j=1:length(run_ball)
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %%%% probe correct
            if strcmp(run_ball{j}(7),'   ball') && cell2mat(run_ball{j}(9))==4 %%% yes I see the ball - button
                probe_correct=[probe_correct; cell2mat(run_ball{j}(10))-cell2mat(run_ball{j}(8))]
            elseif strcmp(run_ball{j}(7),'no_ball') && cell2mat(run_ball{j}(9))==5 %%% no I see no ball - button
                probe_correct=[probe_correct; cell2mat(run_ball{j}(10))-cell2mat(run_ball{j}(8))]
                
                %%%% probe uncorrect
            elseif strcmp(run_ball{j}(7),'   ball') && cell2mat(run_ball{j}(9))==5 %%% no I see no ball - but the ball was there
                probe_uncorrect=[probe_uncorrect; cell2mat(run_ball{j}(10))-cell2mat(run_ball{j}(8))]
            elseif strcmp(run_ball{j}(7),'no_ball') && cell2mat(run_ball{j}(9))==4 %%% yes I see the ball - but there was no ball
                probe_uncorrect=[probe_uncorrect; cell2mat(run_ball{j}(10))-cell2mat(run_ball{j}(8))]
                
                %%% sample no resp
            elseif cell2mat(run_ball{j}(4))==0
                sample_no_resp=[sample_no_resp; 0];
            end
            
        end
        
        length_ball_task=length_ball_task+length(run_ball);
    end
    
    
    
    hitrate_sample=[length(sample_correct)/length_ball_task length(sample_uncorrect)/length_ball_task length(sample_no_resp)/length_ball_task];
    hitrate_probe=[length(probe_correct)/length_ball_task length(probe_uncorrect)/length_ball_task length(probe_no_resp)/length_ball_task];
    
    RT_sample=[mean(sample_correct) mean(sample_uncorrect)];
    RT_probe=[mean(probe_correct) mean(probe_uncorrect)];
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    hit_rep_lures_plot=[hitrate_rep(:,1) hitrate_lures(:,1)];
    RT_rep_lures_plot=[RT_rep(:,1) RT_lures(:,1)];
    
    hit_priv_pub_plot=[hitrate_public(:,1) hitrate_private(:,1)];
    RT_priv_pub_plot=[RT_public(:,1) RT_private(:,1)];
    
    
    
    
    hit_ball=[hitrate_sample(:,1) hitrate_probe(:,1)];
    RT_ball=[RT_sample(:,1) RT_probe(:,1)];
    
    
    
    eval(['figure(''name'',''Subject: ',char(subj_name),''');'])
    subplot(4,2,1);bar(hit_rep_lures_plot);title('hit rate - rep lure');set(gca,'XTickLabel',{'reps','lures',''});axis([0 3 0 1])
    subplot(4,2,2);bar(RT_rep_lures_plot);title('RT - rep lure');set(gca,'XTickLabel',{'reps','lures',''});axis([0 3 0 2500])
    
    subplot(4,2,3);bar(hit_priv_pub_plot);title('hit rate - public private');set(gca,'XTickLabel',{'public','private',''});axis([0 3 0 1])
    subplot(4,2,4);bar(RT_priv_pub_plot);title('RT - public private');set(gca,'XTickLabel',{'public','private',''});axis([0 3 0 2500])
    
    
    
    subplot(4,2,7);bar(hit_ball);title('hit rate - ball task');set(gca,'XTickLabel',{'sample','probe',''});axis([0 3 0 1])
    subplot(4,2,8);bar(RT_ball);title('RT - ball task');set(gca,'XTickLabel',{'sample','probe',''});axis([0 3 0 2000])
    
    average_rep_lure=[average_rep_lure; hit_rep_lures_plot RT_rep_lures_plot];
    average_ball=[average_ball;hit_ball RT_ball];
    average_privare_public=[average_privare_public; hit_priv_pub_plot RT_priv_pub_plot];
    
end

    %%%%%%%%%%%%%% Average over Subjects %%%%%%%%%%%%
    
    mean_rep=mean(average_rep_lure);
    mean_priv=mean(average_privare_public);
    mean_ball=mean(average_ball);
    
    
    figure('name','Mean over all subjects');
    subplot(4,2,1);bar(mean_rep(1:2));title('hit rate - rep lure');set(gca,'XTickLabel',{'reps','lures',''});axis([0 3 0 1])
    subplot(4,2,2);bar(mean_rep(3:4));title('RT - rep lure');set(gca,'XTickLabel',{'reps','lures',''});axis([0 3 0 2500])
    
    subplot(4,2,3);bar(mean_priv(1:2));title('hit rate - public private');set(gca,'XTickLabel',{'public','private',''});axis([0 3 0 1])
    subplot(4,2,4);bar(mean_priv(3:4));title('RT - public private');set(gca,'XTickLabel',{'public','private',''});axis([0 3 0 2500])
    
    subplot(4,2,7);bar(mean_ball(1:2));title('hit rate - ball task');set(gca,'XTickLabel',{'sample','probe',''});axis([0 3 0 1])
    subplot(4,2,8);bar(mean_ball(3:4));title('RT - ball task');set(gca,'XTickLabel',{'sample','probe',''});axis([0 3 0 2000])
    

    
    
