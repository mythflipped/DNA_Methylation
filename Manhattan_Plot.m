% Load Data
data = readtable('your_data.xlsx');  % Replace with your file

% Extract relevant columns
chromosome = data.CHR;       % Chromosome numbers
mapinfo = data.MAPINFO;      % Genomic positions
p_values = data.P_Value;     % P-values

% Convert P-values to -log10 scale
neg_log_p = -log10(p_values);

% Define unique chromosomes and assign colors
unique_chr = unique(chromosome);
num_chr = length(unique_chr);
colors = lines(num_chr);  % MATLAB's default colormap

% Adjust x-axis positions per chromosome
chr_offsets = zeros(size(chromosome));
chr_x_ticks = zeros(num_chr, 1);
x_offset = 0;

for i = 1:num_chr
    chr_idx = chromosome == unique_chr(i);
    chr_positions = mapinfo(chr_idx);
    chr_positions = chr_positions - min(chr_positions) + x_offset;
    
    chr_offsets(chr_idx) = chr_positions;
    chr_x_ticks(i) = mean(chr_positions);
    
    x_offset = max(chr_positions) + 1e6; % Add spacing between chromosomes
end

% Create Manhattan Plot
figure;
hold on;

for i = 1:num_chr
    chr_idx = chromosome == unique_chr(i);
    scatter(chr_offsets(chr_idx), neg_log_p(chr_idx), 10, colors(i,:), 'filled');
end

% Customize plot appearance
xlabel('Chromosome');
ylabel('-log_{10}(p)');
title('Manhattan Plot');
xticks(chr_x_ticks);
xticklabels(unique_chr);
set(gca, 'XTickLabelRotation', 0); % Keep x labels horizontal
xlim([0 max(chr_offsets)]);
ylim([0 max(neg_log_p) + 1]);



% Enhance appearance
box off;
hold off;
