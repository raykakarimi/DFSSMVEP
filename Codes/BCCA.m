%%% Bifold Canonical Correlation Analysis %%%
num_sub = 10;
method={'CCA'};
Fs=500;                                  % sampling rate
H=2;                                     % number of harmonics for reference construction
t_length=4;                              % analysis window length (s)
TW=0.5:0.5:t_length;
t = (0:1/Fs:(t_length*Fs-1)/Fs)';
TW_p=round(TW*Fs);
n_run = 8;                                % number of experimental runs
sti_f=[9 6 5 7 8; 7.5 9.5 8.5 5.5 6.5];   % stimulus modulated frequencies
n_sti=size(sti_f,2);                     % number of stimulus frequencies
% References signal with sine-cosine waveforms
sc11=refsig(sti_f(1,1),Fs,t_length*Fs,H);
sc12=refsig(sti_f(2,1),Fs,t_length*Fs,H);
sc1=[sc11;sc12];
sc21=refsig(sti_f(1,2),Fs,t_length*Fs,H);
sc22=refsig(sti_f(2,2),Fs,t_length*Fs,H);
sc2=[sc21;sc22];
sc31=refsig(sti_f(1,3),Fs,t_length*Fs,H);
sc32=refsig(sti_f(2,3),Fs,t_length*Fs,H);
sc3=[sc31;sc32];
sc41=refsig(sti_f(1,4),Fs,t_length*Fs,H);
sc42=refsig(sti_f(2,4),Fs,t_length*Fs,H);
sc4=[sc41;sc42];
sc51=refsig(sti_f(1,5),Fs,t_length*Fs,H);
sc52=refsig(sti_f(2,5),Fs,t_length*Fs,H);
sc5=[sc51;sc52];
n_correct=zeros(length(TW),num_sub);
itrr=zeros(length(TW),num_sub);
for sub = 1:1:num_sub
%% Load data
% load SSmVEPdata;
    FileName   = [num2str(sub),'_size_c'];
    FolderName = 'DFSSMVEP/Dataset';
    File       = fullfile(FolderName, FileName);
    load(File); 
    load('Hd')
    % 6 channels x 2000 points x 8 trials x 5 Targets
    num_channel = size(trial,2);
    
    %% spatial and time filtering
    SSmVEPdata1=zeros(1,t_length*Fs,n_run,n_sti,num_channel);
    %% SSmVEP recognition
    
    for cros=1:n_run                                  % leave-one-run-out cross-validation
        idx_testdata=cros;
        idx_traindata=1:n_run;
        idx_traindata(idx_testdata)=[];

        for tw_length=1:length(TW)
            switch method{mth}
                case 'CCA'
                    fprintf('CCA Processing TW %fs, No.crossvalidation %d \n',TW(tw_length),cros);
                    % recognize SSmVEP
                    nn=tw_length;
                    for j=1:n_sti
                        for k=1:num_channel
                                a=trial(:,k,j,cros);
                                aa=detrend(a,'constant');
                                aaa=smooth(aa,30,'loess');
                                b(:,k)=bandp(aaa,0.5,50,0.2,60,Fs); %Chebyshev band pass filtering
                                SSmVEPdata1(1,:,cros,j,k) = b(:,k);
                        end
                        [wx10,wy10,r10]=cca(squeeze(SSmVEPdata1(1,1:TW_p(tw_length),idx_testdata,j,:))',sc1(:,1:TW_p(tw_length)));
                        [wx11,wy11,r11]=cca(squeeze(SSmVEPdata1(1,1:TW_p(tw_length),idx_testdata,j,:))',sc11(:,1:TW_p(tw_length)));
                        [wx12,wy12,r12]=cca(squeeze(SSmVEPdata1(1,1:TW_p(tw_length),idx_testdata,j,:))',sc12(:,1:TW_p(tw_length)));

                        [wx20,wy20,r20]=cca(squeeze(SSmVEPdata1(1,1:TW_p(tw_length),idx_testdata,j,:))',sc2(:,1:TW_p(tw_length)));
                        [wx21,wy21,r21]=cca(squeeze(SSmVEPdata1(1,1:TW_p(tw_length),idx_testdata,j,:))',sc21(:,1:TW_p(tw_length)));
                        [wx22,wy22,r22]=cca(squeeze(SSmVEPdata1(1,1:TW_p(tw_length),idx_testdata,j,:))',sc22(:,1:TW_p(tw_length)));

                        [wx30,wy30,r30]=cca(squeeze(SSmVEPdata1(1,1:TW_p(tw_length),idx_testdata,j,:))',sc3(:,1:TW_p(tw_length)));
                        [wx31,wy31,r31]=cca(squeeze(SSmVEPdata1(1,1:TW_p(tw_length),idx_testdata,j,:))',sc31(:,1:TW_p(tw_length)));
                        [wx32,wy32,r32]=cca(squeeze(SSmVEPdata1(1,1:TW_p(tw_length),idx_testdata,j,:))',sc32(:,1:TW_p(tw_length)));

                        [wx40,wy40,r40]=cca(squeeze(SSmVEPdata1(1,1:TW_p(tw_length),idx_testdata,j,:))',sc4(:,1:TW_p(tw_length)));
                        [wx41,wy41,r41]=cca(squeeze(SSmVEPdata1(1,1:TW_p(tw_length),idx_testdata,j,:))',sc41(:,1:TW_p(tw_length)));
                        [wx42,wy42,r42]=cca(squeeze(SSmVEPdata1(1,1:TW_p(tw_length),idx_testdata,j,:))',sc42(:,1:TW_p(tw_length)));

                        [wx50,wy50,r50]=cca(squeeze(SSmVEPdata1(1,1:TW_p(tw_length),idx_testdata,j,:))',sc5(:,1:TW_p(tw_length)));
                        [wx51,wy51,r51]=cca(squeeze(SSmVEPdata1(1,1:TW_p(tw_length),idx_testdata,j,:))',sc51(:,1:TW_p(tw_length)));
                        [wx52,wy52,r52]=cca(squeeze(SSmVEPdata1(1,1:TW_p(tw_length),idx_testdata,j,:))',sc52(:,1:TW_p(tw_length)));

                        [v,idx]=max([max(mean([r10,r11,r12],2)),max(mean([r20,r21,r22],2)),max(mean([r30,r31,r32],2)),max(mean([r40,r41,r42],2)),max(mean([r50,r51,r52],2))]);

                        if idx==j
                            n_correct(tw_length,sub)=n_correct(tw_length,sub)+1;
                        end
                    end

            end
        end
        
    end
for tw_length=1:length(TW)
    itrr(tw_length,sub)=itr(n_sti,n_correct(tw_length,sub)/n_sti/n_run,TW(tw_length));
end
end
%% Plot results
accuracy = 100*mean(n_correct/n_sti/n_run,2);
error = std(100*(n_correct/n_sti/n_run),0,2);
color={'b-*','r-o','g'};
for mth=1:n_meth
    errorbar(TW,accuracy,error,color{mth},'LineWidth',1);
    hold on;
end
xlabel('Time window (s)');
ylabel('Accuracy (%)');
xlim([0.25 4.25]);
set(gca,'xtick',0.5:0.5:4,'xticklabel',0.5:0.5:4);
ylim([30 100]);
title('\bf  BifoldCCA SSMVEP Recognition');
