%New trajectories by DUCK-HA HWANG

%------solve diff holo dislocation, change xyz coordinate information.

threshold_diff_dislocation= 1.3; %*****check it!! important value (1+1*30%) for combining close coordinates
control_vecter_angle = 23;


fps=3; %fps means frame per second
distance_threshold_fast = (120/fps)/pixelsize; %******threshold object tracking. need to control. maximum ditance to distinguish as a same object
%unit is um. // I limited that the fasted sperm's speed is 110 um/sec.
%fps means frame per second

for combine_compare_loop=1:iter-2
    
    behind_compare=combine_compare_loop+1;
    
    maxsize_cmb_cp=size(xyz{1,combine_compare_loop}); %read size
    
    maxsize_cmb_cp2=size(xyz{1,behind_compare}); %read size

    
    for inft_loop=1:maxsize_cmb_cp(1,1)
        for bhid_loop=1:maxsize_cmb_cp2(1,1)

            xx_shrt = xyz{1,combine_compare_loop}(inft_loop,1) - xyz{1,behind_compare}(bhid_loop,1); % comparing x coordinates
            yy_shrt = xyz{1,combine_compare_loop}(inft_loop,2) - xyz{1,behind_compare}(bhid_loop,2); % comparing y coordinates
        
            distance_shrt_limit= sqrt((xx_shrt^2)+(yy_shrt^2));

            if (distance_shrt_limit <= threshold_diff_dislocation)         
                xyz{1,behind_compare}(bhid_loop,1) = xyz{1,combine_compare_loop}(inft_loop,1);
                xyz{1,behind_compare}(bhid_loop,2) = xyz{1,combine_compare_loop}(inft_loop,2);
                
            end
        end
    end
    
end

%------change xyz


fast_obj_start=1; % if you need to find starting point on the middle of frame, then you need to change the value as a loop(for function)
maxsize_fast_xyz=size(xyz{1,fast_obj_start}); %read size  

object_number_count=0;

for inside_loop=1:maxsize_fast_xyz(1,1)-1

    count_distance_num=0;
    distance_fast_mat=0;
    

    for inside_bhd=inside_loop+1:maxsize_fast_xyz(1,1)

        count_distance_num=count_distance_num+1;
       
        xx_1 = xyz{1,fast_obj_start}(inside_bhd,1) - xyz{1,fast_obj_start}(inside_loop,1); % comparing x coordinates   
        yy_1 = xyz{1,fast_obj_start}(inside_bhd,2) - xyz{1,fast_obj_start}(inside_loop,2); % comparing y coordinates
    
        distance_fast_mat(count_distance_num,1) = sqrt((xx_1^2)+(yy_1^2));
            
    end

    [row_dist,col_dist,check_dist]=find(distance_fast_mat <= distance_threshold_fast);
        
    if (check_dist == 1) %first distance threshold check
        
        row_dist_size=size(row_dist); %read size  
        angle_fast=0;
        dist_thresh_sec=0;
      
        for try_loop = 1: row_dist_size(1,1)
            

            if (min_intensities_xyz{1,fast_obj_start}(inside_loop) > min_intensities_xyz{1,fast_obj_start}(inside_loop+row_dist(try_loop))) % compare intensity to decide before one. smaller intensity means later one       
                %decide vector andgle
                %each magnitude
                angle_fast = (atan((xyz{1,fast_obj_start}(inside_loop+row_dist(try_loop),2)-xyz{1,fast_obj_start}(inside_loop,2))/(xyz{1,fast_obj_start}(inside_loop+row_dist(try_loop),1)-xyz{1,fast_obj_start}(inside_loop,1))))*180/pi; % unit is degree
                dist_thresh_sec = distance_fast_mat(row_dist(try_loop));
                
                %first xyz{1,fast_obj_start}(inside_loop,1), xyz{1,fast_obj_start}(inside_loop,2)
                %second xyz{1,fast_obj_start}(inside_loop+row_dist(try_loop),1),xyz{1,fast_obj_start}(inside_loop+row_dist(try_loop),2)
                
                sec_dist_size=size(xyz{1,fast_obj_start+1}); %read size 
                
                distance_secd_mat=0;
                
                for dist_cmp_loop = 1: sec_dist_size(1,1)
                    
                    
                    xx_2 = xyz{1,fast_obj_start+1}(dist_cmp_loop,1) - xyz{1,fast_obj_start}((inside_loop+row_dist(try_loop)),1);
                    yy_2 = xyz{1,fast_obj_start+1}(dist_cmp_loop,2) - xyz{1,fast_obj_start}((inside_loop+row_dist(try_loop)),2);
                
                    distance_secd_mat(dist_cmp_loop,1) = sqrt((xx_2^2)+(yy_2^2));
                    
                end
                
                [row_secd,col_secd,check_secd]=find(distance_secd_mat < dist_thresh_sec * (1.3) & distance_secd_mat > dist_thresh_sec * (0.7) & distance_secd_mat ~= dist_thresh_sec);
                
                if (check_secd == 1)
              
                    row_secd_size=size(row_secd); %read size  
                    angle_secd_fast=0;
                    dist_thresh_third=0;
                   
                    for find_secd_loop = 1: row_secd_size(1,1)
                        if(dist_thresh_sec*1.3 < sqrt( (xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),1)-xyz{1,fast_obj_start}(inside_loop,1))^2+(xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),2)-xyz{1,fast_obj_start}(inside_loop,2))^2 ))
                        if(angle_fast+control_vecter_angle > atan((xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),2)-xyz{1,fast_obj_start}((inside_loop+row_dist(try_loop)),2))/((xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),1))-xyz{1,fast_obj_start}((inside_loop+row_dist(try_loop)),1)))*180/pi & angle_fast-control_vecter_angle < atan((xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),2)-xyz{1,fast_obj_start}((inside_loop+row_dist(try_loop)),2))/((xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),1))-xyz{1,fast_obj_start}((inside_loop+row_dist(try_loop)),1)))*180/pi) % unit is degree
             
                            angle_secd_fast = atan((xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),2)-xyz{1,fast_obj_start}((inside_loop+row_dist(try_loop)),2))/((xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),1))-xyz{1,fast_obj_start}((inside_loop+row_dist(try_loop)),1)))*180/pi;
                            dist_thresh_third = distance_secd_mat(row_secd(find_secd_loop));
                            % finish third check
                            % (xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),1)),(xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),2))
                            
                            thrd_dist_size=size(xyz{1,fast_obj_start+2}); %read size 
                            distance_thrd_mat=0;
                            
                            for dist_thrd_loop = 1: thrd_dist_size(1,1)
                                
                                xx_3 = xyz{1,fast_obj_start+2}(dist_thrd_loop,1) - (xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),1));
                                yy_3 = xyz{1,fast_obj_start+2}(dist_thrd_loop,2) - (xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),2));

                                distance_thrd_mat(dist_thrd_loop,1) = sqrt((xx_3^2)+(yy_3^2));
                                
                            end
                                          
                            [row_third,col_third,check_third]=find(distance_thrd_mat <= dist_thresh_third * (1.3) & distance_thrd_mat >= dist_thresh_third * (0.7));
                
                            if (check_third == 1)
                               
                                row_third_size=size(row_third);
                                angle_rest_th=0;
                                dist_rest_th=0;
                                
                                
                                           
                                for find_rest_loop = 1: row_third_size(1,1)
                                      if(dist_thresh_third*1.3 < sqrt( (xyz{1,fast_obj_start+2}(row_third(find_rest_loop),1)-xyz{1,fast_obj_start}(inside_loop,1))^2+(xyz{1,fast_obj_start+2}(row_third(find_rest_loop),2)-xyz{1,fast_obj_start}(inside_loop,2))^2 ))            
                                      if(angle_secd_fast+control_vecter_angle > atan((xyz{1,fast_obj_start+2}(row_third(find_rest_loop),2)-(xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),2)))/(xyz{1,fast_obj_start+2}(row_third(find_rest_loop),1)-(xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),1))))*180/pi & angle_secd_fast-control_vecter_angle < atan((xyz{1,fast_obj_start+2}(row_third(find_rest_loop),2)-(xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),2)))/(xyz{1,fast_obj_start+2}(row_third(find_rest_loop),1)-(xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),1))))*180/pi)     
   
                                        angle_rest_th=atan((xyz{1,fast_obj_start+2}(row_third(find_rest_loop),2)-(xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),2)))/(xyz{1,fast_obj_start+2}(row_third(find_rest_loop),1)-(xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),1))))*180/pi;
                                        dist_rest_th=distance_thrd_mat(row_third(find_rest_loop));
                                        
                                        %fourth xyz{1,fast_obj_start+2}(row_third(find_third_loop),1),xyz{1,fast_obj_start+2}(row_third(find_third_loop),2)
                                        
                                        find_coor_answer=row_third(find_rest_loop);
                                        object_number_count = object_number_count+1;
                                                 
                                        fst_mv_oj_coor=0;
                                        
                                        fst_mv_oj_coor(1,1) = xyz{1,fast_obj_start}(inside_loop,1);                              
                                        fst_mv_oj_coor(1,2) = xyz{1,fast_obj_start}(inside_loop,2);          
                                        fst_mv_oj_coor(1,3) = 2; %fast moving value is 2
                                        fst_mv_oj_coor(1,4) = object_number_count;
                                   
                                        fst_mv_oj_coor(2,1) = xyz{1,fast_obj_start}(inside_loop+row_dist(try_loop),1);
                                        fst_mv_oj_coor(2,2) = xyz{1,fast_obj_start}(inside_loop+row_dist(try_loop),2);          
                                        fst_mv_oj_coor(2,3) = 2; %fast moving value is 2
                                        fst_mv_oj_coor(2,4) = object_number_count;
                                   
                                        fst_mv_oj_coor(3,1) = xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),1);
                                        fst_mv_oj_coor(3,2) = xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),2);          
                                        fst_mv_oj_coor(3,3) = 2; %fast moving value is 2
                                        fst_mv_oj_coor(3,4) = object_number_count;
                                        
                                        fst_mv_oj_coor(4,1) = xyz{1,fast_obj_start+2}(find_coor_answer,1);
                                        fst_mv_oj_coor(4,2) = xyz{1,fast_obj_start+2}(find_coor_answer,2);          
                                        fst_mv_oj_coor(4,3) = 2; %fast moving value is 2
                                        fst_mv_oj_coor(4,4) = object_number_count;
                                  
                                        fast_total_coor(1,object_number_count)={fst_mv_oj_coor};
                                       

                                    end
                                    end
                                end
                                
                            end
                            
                        end
                        end   
                    end
        
                end

                
            else
                %need to change order for first
                
                angle_fast = (atan((xyz{1,fast_obj_start}(inside_loop,2)-xyz{1,fast_obj_start}(inside_loop+row_dist(try_loop),2))/(xyz{1,fast_obj_start}(inside_loop,1)-xyz{1,fast_obj_start}(inside_loop+row_dist(try_loop),1))))*180/pi; % unit is degree
                dist_thresh_sec = distance_fast_mat(row_dist(try_loop));
                  
                %first xyz{1,fast_obj_start}(inside_loop+row_dist(try_loop),1),xyz{1,fast_obj_start}(inside_loop+row_dist(try_loop),2)
                %second xyz{1,fast_obj_start}(inside_loop,1), xyz{1,fast_obj_start}(inside_loop,2)
         
                sec_dist_size=size(xyz{1,fast_obj_start+1}); %read size 
                
                distance_secd_mat=0;
                
                for dist_cmp_loop = 1: sec_dist_size(1,1)
                    
                    
                    xx_2 = xyz{1,fast_obj_start+1}(dist_cmp_loop,1) - xyz{1,fast_obj_start}((inside_loop+row_dist(try_loop)),1);
                    yy_2 = xyz{1,fast_obj_start+1}(dist_cmp_loop,2) - xyz{1,fast_obj_start}((inside_loop+row_dist(try_loop)),2);
                
                    distance_secd_mat(dist_cmp_loop,1) = sqrt((xx_2^2)+(yy_2^2));
                    
                end
                
                [row_secd,col_secd,check_secd]=find(distance_secd_mat < dist_thresh_sec * (1.3) & distance_secd_mat > dist_thresh_sec * (0.7) & distance_secd_mat ~= dist_thresh_sec);
                
                if (check_secd == 1)
                 
                    row_secd_size=size(row_secd); %read size  
                    angle_secd_fast=0;
                    dist_thresh_third=0;
                 
                    for find_secd_loop = 1: row_secd_size(1,1)
                        if(dist_thresh_sec*1.3 < sqrt( (xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),1)-xyz{1,fast_obj_start}(inside_loop+row_dist(try_loop),1))^2+(xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),2)-xyz{1,fast_obj_start}(inside_loop+row_dist(try_loop),2))^2 ))
                        if(angle_fast+control_vecter_angle > atan((xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),2)-xyz{1,fast_obj_start}((inside_loop+row_dist(try_loop)),2))/((xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),1))-xyz{1,fast_obj_start}((inside_loop+row_dist(try_loop)),1)))*180/pi & angle_fast-control_vecter_angle < atan((xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),2)-xyz{1,fast_obj_start}((inside_loop+row_dist(try_loop)),2))/((xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),1))-xyz{1,fast_obj_start}((inside_loop+row_dist(try_loop)),1)))*180/pi) % unit is degree
             
                            angle_secd_fast = atan((xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),2)-xyz{1,fast_obj_start}((inside_loop+row_dist(try_loop)),2))/((xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),1))-xyz{1,fast_obj_start}((inside_loop+row_dist(try_loop)),1)))*180/pi;
                            dist_thresh_third = distance_secd_mat(row_secd(find_secd_loop));
                            % finish third check
                            % (xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),1)),(xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),2))
                            
                            thrd_dist_size=size(xyz{1,fast_obj_start+2}); %read size 
                            distance_thrd_mat=0;
                            
                            for dist_thrd_loop = 1: thrd_dist_size(1,1)
                                
                                xx_3 = xyz{1,fast_obj_start+2}(dist_thrd_loop,1) - (xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),1));
                                yy_3 = xyz{1,fast_obj_start+2}(dist_thrd_loop,2) - (xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),2));

                                distance_thrd_mat(dist_thrd_loop,1) = sqrt((xx_3^2)+(yy_3^2));
                                
                            end
                            
                            [row_third,col_third,check_third]=find(distance_thrd_mat <= dist_thresh_third * (1.3) & distance_thrd_mat >= dist_thresh_third * (0.7));
                
                            if (check_third == 1)
                               
                                row_third_size=size(row_third);
                                angle_rest_th=0;
                                dist_rest_th=0;
                                
                                
                                       
                                for find_rest_loop = 1: row_third_size(1,1)
                                   
                                    if(dist_thresh_third*1.3 < sqrt( (xyz{1,fast_obj_start+2}(row_third(find_rest_loop),1)-xyz{1,fast_obj_start}(inside_loop,1))^2+(xyz{1,fast_obj_start+2}(row_third(find_rest_loop),2)-xyz{1,fast_obj_start}(inside_loop,2))^2 ))
                                    if(angle_secd_fast+control_vecter_angle > atan((xyz{1,fast_obj_start+2}(row_third(find_rest_loop),2)-(xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),2)))/(xyz{1,fast_obj_start+2}(row_third(find_rest_loop),1)-(xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),1))))*180/pi & angle_secd_fast-control_vecter_angle < atan((xyz{1,fast_obj_start+2}(row_third(find_rest_loop),2)-(xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),2)))/(xyz{1,fast_obj_start+2}(row_third(find_rest_loop),1)-(xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),1))))*180/pi)     

                                        angle_rest_th=atan((xyz{1,fast_obj_start+2}(row_third(find_rest_loop),2)-(xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),2)))/(xyz{1,fast_obj_start+2}(row_third(find_rest_loop),1)-(xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),1))))*180/pi;
                                        dist_rest_th=distance_thrd_mat(row_third(find_rest_loop));
                                        
                                        %fourth xyz{1,fast_obj_start+2}(row_third(find_third_loop),1),xyz{1,fast_obj_start+2}(row_third(find_third_loop),2)
                                        
                                        find_coor_answer=row_third(find_rest_loop);
                                        object_number_count = object_number_count+1;
                                                
                                        fst_mv_oj_coor=0;
                                        
                                        fst_mv_oj_coor(1,1) = xyz{1,fast_obj_start}(inside_loop+row_dist(try_loop),1);                              
                                        fst_mv_oj_coor(1,2) = xyz{1,fast_obj_start}(inside_loop+row_dist(try_loop),2);          
                                        fst_mv_oj_coor(1,3) = 2; %fast moving value is 2
                                        fst_mv_oj_coor(1,4) = object_number_count;
                                   
                                        fst_mv_oj_coor(2,1) = xyz{1,fast_obj_start}(inside_loop,1);
                                        fst_mv_oj_coor(2,2) = xyz{1,fast_obj_start}(inside_loop,2);          
                                        fst_mv_oj_coor(2,3) = 2; %fast moving value is 2
                                        fst_mv_oj_coor(2,4) = object_number_count;
                                   
                                        fst_mv_oj_coor(3,1) = xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),1);
                                        fst_mv_oj_coor(3,2) = xyz{1,fast_obj_start+1}(row_secd(find_secd_loop),2);          
                                        fst_mv_oj_coor(3,3) = 2; %fast moving value is 2
                                        fst_mv_oj_coor(3,4) = object_number_count;
                                        
                                        fst_mv_oj_coor(4,1) = xyz{1,fast_obj_start+2}(find_coor_answer,1);
                                        fst_mv_oj_coor(4,2) = xyz{1,fast_obj_start+2}(find_coor_answer,2);         
                                        fst_mv_oj_coor(4,3) = 2; %fast moving value is 2
                                        fst_mv_oj_coor(4,4) = object_number_count;
                                        
                                        fast_total_coor(1,object_number_count)={fst_mv_oj_coor};                           

                                    end
                                    end
                                    
                                end %finish first find_rest loop
                               
                            end
                            
                        end
                        end   
                    end
        
                end
                
                
            end%intensity
            end
        end
    end
        


%*******figure*****

figure
imshow((abs(recon_stack(:,:,1))+abs(recon_stack(:,:,2)))/2,[])
hold on

dddeee= size(fast_total_coor);

for pictureN=1:dddeee(1,2)
hold on
plot((fast_total_coor{1,pictureN}(:,1)),(fast_total_coor{1,pictureN}(:,2)),'g')
hold on
plot((fast_total_coor{1,pictureN}(1,1)),(fast_total_coor{1,pictureN}(1,2)),'b.')

end


figure, imshow(recon_stack_diff(:,:,1),[])
hold on
plot(xyz{1,1}(:,1),xyz{1,1}(:,2),'g.')
 
set(gca, 'XLim', [1880, 1930], 'YLim', [1675, 1720])
axis on
