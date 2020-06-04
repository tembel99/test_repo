close all
clc
clear

%%
DriveFolder=computer_name_identification();

%% directories pathways
% C:\Users\user\OneDrive - Technion
eval(['cd_drive_misc=''',DriveFolder,'\misc'';']);
eval(['cd_drive_mfiles=''',DriveFolder,'\mfiles'';']);
eval(['cd_drive_meetings=''',DriveFolder,'\meetings\'';']);
eval(['cd_drive_results=''',DriveFolder,'\results\'';']);
% cd_PIV_Results='I:\PIV\Results';
% cd_PIV_Images='I:\PIV\Images';

eval(['load(''',cd_drive_results,'\Figures\PIC\calibration_correction.mat'');']);
% eval(['pcolor_comparison=''',DriveFolder,'\meetings\methods\concentration\PIC\pcolor_comparison\'';']);
eval(['load(''',cd_drive_misc,'\x_cm_z_cm.mat'');']);
eval(['load(''',cd_drive_misc,'\resuspension_dates.mat'');']);

%%
% for i_resuspension=1:length(resuspension_dates.day)
for i_resuspension=4
    
    set_year_str=num2str((resuspension_dates.year(i_resuspension)),'%02.2d');
    set_month_str=num2str((resuspension_dates.month(i_resuspension)),'%02.2d');
    set_day_str=num2str((resuspension_dates.day(i_resuspension)),'%02.2d');   
    
%     case_name=resuspension_dates.cases(i_resuspension);
%     case_str=cell2mat(case_name);
    
    eval(['x_cm=x_cm_z_cm.x_cm_z_cm_',set_year_str,set_month_str,set_day_str,'.x_cm;']);
    eval(['z_cm=x_cm_z_cm.x_cm_z_cm_',set_year_str,set_month_str,set_day_str,'.z_cm;']);

    eval(['c_avg=calibration_correction.cc_',set_year_str,set_month_str,set_day_str,'.c_avg;']);
    eval(['C_im_mean=calibration_correction.cc_',set_year_str,set_month_str,set_day_str,'.C_im_mean;']);

    % use inpaint_nans for NaN's in c_avg and C_im_mean.     
    c=zeros(31,42,2);
    c(:,:,1)=inpaint_nans(c_avg);
    c(:,:,2)=inpaint_nans(C_im_mean);
    max_c=max([max(max(c(:,:,1))) max(max(c(:,:,2)))]);
    % pcolor figures
%     title_subplot={'before correction';'after correction'};
    dim_ann_w=[0.0293,0.5011];
    dim_ann_h=[0.902,0.902];
%     str_ann={'(a)','(b)'};
    str_ann={'(c)','(d)'};
    c_bar_Label_Position_x=[0.3322,0.3878];
%     c_bar_Label_Position_z=53.54;
    c_bar_Label_Position_z=71.42;
    figure('Color',[1 1 1],'Position',[100 100 535 250]);
%     sgtitle(case_str);
    ha = tight_subplot(1,2,.03,[.175 .085],[.075 .001]);
        for ii = 1:2
            axes(ha(ii)); 
            pcolor(x_cm,z_cm,c(:,:,ii)),shading interp; 
            caxis([0 max_c]);
            
            ax = gca;
            ax.FontSize = 10;
%             ax.YTickLabel = 2:2:10;
%             ax.YLim = [1 10];
%             ax.TickDir = 'out';
            c_bar = colorbar;
            c_bar.Label.Interpreter = 'latex';
            c_bar.Label.String = '$\overline{C}$ $(mg$ $L^{-1})$';
            c_bar.Label.FontSize = 10;
            c_bar.Label.FontWeight = 'Bold'; 
            c_bar.Label.Rotation = 0;
            c_bar.Label.Position = [c_bar_Label_Position_x(ii), c_bar_Label_Position_z];
%               pause

            dim_ann_1 = [dim_ann_w(ii), dim_ann_h(ii), 0.069,0.1296];
            t=annotation('textbox',dim_ann_1,'String',str_ann(ii),'FitBoxToText','on','FontSize',12);
            t.EdgeColor = 'none';
            xlabel('$x$ $(cm)$','FontSize',12,'interpreter','latex'); 
            if ii==1
              ylabel('$z$ $(cm)$','FontSize',12,'interpreter','latex');
            end
%               title(title_subplot(ii),'Fontsize',12);
        end
%     pause;
%     eval(['saveas(gcf,[''',pcolor_comparison,'conc_correction_',set_year_str,set_month_str,set_day_str,'.jpg'']);']);
%     close all
    
end


