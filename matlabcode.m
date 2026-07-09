%% CHE 212 / Heat Transfer Lab - Integrated Analysis
clear; close all; clc;

%% 1. Constants and Shared Data
u       = 3.0;               
nu_air  = 1.76e-5;           
Pr      = 0.70;              
k       = 0.0276;            
delta_y = 1e-3;              
x_cm    = [5 10 15 20];      
x_m     = x_cm / 100;        
voltLabels = ["100 V","120 V","150 V"];
velLabels  = {'N/A', '3.0 m/s'}; 
markerList = {'o','s','^','d'};  

%% 2. Experimental Data Sets
delta_exp_mm = [ ...
     5.0  7.0  8.0 10.0;   
     5.0  8.0 10.0 11.0;   
     7.0  9.0 11.0 15.0 ];  

Nu_exp_forced = [ ...
    28.7 70.4 63.3 140.1;   
    10.2 26.0 42.1 77.1;    
    14.9 22.0 33.6 14.4 ];  

Nu_forced = [ ...
    36.9 52.2 63.9 73.8;     
    36.6 51.7 63.4 73.2;     
    36.0 50.9 62.4 72.0 ];   

Nu_mixed = [ ...
    37.0 52.6 64.3 74.3;     
    36.7 52.2 64.2 74.1;     
    36.4 51.5 63.3 73.8 ];   

oldErr_forced = [ ...
    22.2 35.0 0.9 90.0;
    72.3 50.2 34.1 4.7;
    59.6 57.9 47.4 80.5 ];

newErr_mixed = [ ...
    22.6 34.1 1.4 89.1;
    72.4 50.5 35.0 3.1;
    60.0 58.4 48.1 81.0 ];

h_exp_100   = [15.94 19.58 11.73 19.48];
h_forced_100= [20.5  14.5  11.8  10.3 ];
h_mixed_100 = [20.6  14.6  11.9  10.3 ];
h_exp_120   = [5.68  7.22  7.80 10.72];
h_forced_120= [20.5  14.5  11.8  10.2 ];
h_mixed_120 = [20.6  14.6  12.0  10.4 ];
h_exp_150   = [8.28  6.11  6.23  2.00];
h_forced_150= [20.5  14.5  11.9  10.3 ];
h_mixed_150 = [20.7  14.7  12.0  10.5 ];

Hexp = {h_exp_100, h_exp_120, h_exp_150};
Hf   = {h_forced_100, h_forced_120, h_forced_150};
Hm   = {h_mixed_100, h_mixed_120, h_mixed_150};

y_coords = { (0:11)', (0:12)', (0:16)' }; 
T_data{1} = [64.6 58.5 55.0 56.5; 47.5 43.6 48.2 43.3; 42.9 41.7 44.4 41.3; ...
             38.4 40.3 42.0 40.7; 36.5 38.9 40.5 40.3; 35.0 38.0 39.8 39.8; ...
             35.0 37.5 39.4 39.5; NaN  37.5 39.2 39.2; NaN  NaN  39.0 38.8; ...
             NaN  NaN  39.0 38.2; NaN  NaN  NaN  37.8; NaN  NaN  NaN  37.8 ];
T_data{2} = [59.6 63.8 62.8 58.6; 56.0 58.1 56.3 51.3; 51.6 55.3 51.8 49.1; ...
             46.5 49.8 48.8 46.0; 43.2 46.7 46.7 44.8; 42.1 44.5 45.1 43.5; ...
             42.1 43.1 43.6 42.5; NaN  42.3 42.4 41.7; NaN  42.0 41.2 41.1; ...
             NaN  42.0 40.5 40.4; NaN  NaN  39.8 40.0; NaN  NaN  39.8 39.8; ...
             NaN  NaN  NaN  39.8 ];
T_data{3} = [75.5 71.5 72.6 69.1; 65.0 65.3 66.1 67.4; 60.1 61.2 62.1 62.4; ...
             52.9 55.4 55.6 57.6; 46.0 51.8 51.1 56.2; 43.5 48.5 49.4 54.7; ...
             41.8 46.2 48.0 52.5; 40.5 44.8 46.8 50.3; 40.5 43.8 45.7 49.6; ...
             NaN  43.5 44.8 48.8; NaN  43.5 44.1 48.1; NaN  NaN  43.8 47.5; ...
             NaN  NaN  43.8 46.7; NaN  NaN  NaN  46.3; NaN  NaN  NaN  45.8; ...
             NaN  NaN  NaN  44.8; NaN  NaN  NaN  43.6 ];

%% 3. Theoretical Calculations
Re_x = u .* x_m ./ nu_air;
delta_theo_m  = 5 .* x_m ./ (sqrt(Re_x) .* Pr^(1/3));
delta_theo_mm  = 1000 .* delta_theo_m;

%% 4. FIGURE 1: Thermal boundary layer thickness comparison
figure('Color','w','Position',[100 100 1800 520]);
tiledlayout(1,3,'Padding','compact','TileSpacing','compact');
for i = 1:3
    nexttile; hold on; grid on;
    plot(x_cm, delta_exp_mm(i,:), 'o-', 'LineWidth', 1.8, 'MarkerSize', 6);
    plot(x_cm, delta_theo_mm, 's--', 'LineWidth', 1.8, 'MarkerSize', 6);
    xlabel('x (cm)');
    ylabel('\delta_t (mm)');
    title(sprintf('Thermal boundary layer: %s', voltLabels(i)));
    legend('Experimental','Theoretical','Location','best');
end
sgtitle('Thermal boundary-layer thickness comparison');

%% 5. FIGURE 2: Nu Comparison
figure('Color','w','Position', [100 100 1800 520]);
tiledlayout(1,3,'Padding','compact','TileSpacing','compact');
for i = 1:3
    nexttile; hold on; grid on;
    plot(x_cm, Nu_exp_forced(i,:), 'ko-', 'LineWidth', 1.8, 'MarkerSize', 6);
    plot(x_cm, Nu_forced(i,:), 's--', 'LineWidth', 1.8, 'MarkerSize', 6);
    plot(x_cm, Nu_mixed(i,:), 'd--', 'LineWidth', 1.8, 'MarkerSize', 6);
    xlabel('x (cm)'); ylabel('Nu_x (-)');
    title(sprintf('Forced vs mixed convection: %s', voltLabels(i)));
    legend('N u_{exp}','N u_{forced}','N u_{mixed}','Location','best');
end
sgtitle('Local Nusselt number: forced vs mixed convection');

%% 6. FIGURE 3: Error Comparison
figure('Color','w','Position', [100 100 1800 520]);
tiledlayout(1,3,'Padding','compact','TileSpacing','compact');
for i = 1:3
    nexttile; hold on; grid on;
    bar(x_cm, [oldErr_forced(i,:)' newErr_mixed(i,:)'], 'grouped');
    xlabel('x (cm)'); ylabel('Error (%)');
    title(sprintf('Forced vs mixed error: %s', voltLabels(i)));
    legend('Old error','New error (mixed)','Location','best');
end
sgtitle('Percentage error: forced vs mixed convection');

%% 7. FIGURE 4: Local h_x Comparison
figure('Color','w','Name','h_x Comparison','Position', [100 100 1800 520]);
tiledlayout(1,3,'Padding','compact','TileSpacing','compact');
for i = 1:3
    nexttile; hold on; grid on; box on;
    plot(x_cm, Hexp{i}, '-o', 'LineWidth', 2, 'MarkerSize', 7);
    plot(x_cm, Hf{i},   '-s', 'LineWidth', 2, 'MarkerSize', 7);
    plot(x_cm, Hm{i},   '-^', 'LineWidth', 2, 'MarkerSize', 7);
    xlabel('x (cm)'); ylabel('h_x (W/m^2K)');
    title(['Local h_x comparison, ' char(voltLabels(i))]);
    legend('Experimental','Forced theory','Mixed / corrected','Location','best');
end

%% 8. FIGURE 5: Temperature Profiles
for iv = 1:3
    figure('Color','w','Name', ['Profile ' char(voltLabels(iv))]);
    hold on;
    current_T = T_data{iv};
    current_y = y_coords{iv};
    for ix = 1:numel(x_cm)
        valid_idx = ~isnan(current_T(:,ix));
        plot(current_y(valid_idx), current_T(valid_idx, ix), ['-', markerList{ix}], ...
            'LineWidth', 1.2, 'MarkerSize', 5, ...
            'DisplayName', sprintf('x = %d cm', x_cm(ix)));
    end
    grid on; box on;
    xlabel('y (mm)'); ylabel('T (^{\circ}C)');
    title(sprintf('Temperature Profile: u = %s, V = %s', velLabels{2}, voltLabels{iv}));
    legend('Location','best');
end

%% 9. FIGURE 6: Contour Maps
figure('Color','w','Units','normalized','Position',[0.1 0.2 0.8 0.4]);
t1 = tiledlayout(1,3,'Padding','compact','TileSpacing','compact');
for iv = 1:3
    nexttile;
    current_y = y_coords{iv};
    current_T = T_data{iv};
    x_all = []; y_all = []; T_all = [];
    for ix = 1:numel(x_cm)
        idx = ~isnan(current_T(:,ix));
        x_all = [x_all; repmat(x_cm(ix), sum(idx), 1)];
        y_all = [y_all; current_y(idx)];
        T_all = [T_all; current_T(idx,ix)];
    end
    [Xq, Yq] = meshgrid(linspace(min(x_cm), max(x_cm), 100), linspace(min(current_y), max(current_y), 100));
    Tq = griddata(x_all, y_all, T_all, Xq, Yq, 'natural');
    contourf(Xq, Yq, Tq, 20, 'LineColor', 'none');
    colorbar; xlabel('x (cm)'); ylabel('y (mm)');
    title(['Temp Map: ' char(voltLabels(iv))]); grid on;
end
title(t1, 'Heat Map Distribution Over Plate', 'FontSize', 14, 'FontWeight', 'bold');

%% 10. FIGURE 7: Experimental Wall Heat Flux
T0 = [T_data{1}(1,:); T_data{2}(1,:); T_data{3}(1,:)];
T1 = [T_data{1}(2,:); T_data{2}(2,:); T_data{3}(2,:)];
qexp = -k .* ((T1 - T0) ./ delta_y); 
figure('Color','w','Name', 'Wall Heat Flux');
t2 = tiledlayout(3,1,'Padding','compact','TileSpacing','compact');
matlabColors = ["#0072BD", "#D95319", "#EDB120"];
for i = 1:3
    nexttile; hold on; grid on;
    plot(x_cm, qexp(i,:), 'o-', 'LineWidth', 1.8, 'MarkerSize', 6, 'Color', matlabColors(1));
    xlabel('x (cm)'); ylabel('q''''_{exp} (W/m^2)');
    title(sprintf('Wall heat flux from temperature gradient at %s', voltLabels(i)));
end
sgtitle('Experimental wall heat flux from Fourier''s law');