%Guilherme Mendes Nº98731
%Tomás Martins Nº93911
%ISCTE

start_nodes =  [1 1 1 2 2 2 3 3 4 4 5 6 6 7 8 9 9 10 11 12 12];
target_nodes = [4 8 11 3 5 10 9 14 5 11 6 7 12 8 9 10 13 14 12 13 14];
weights = [1136 2828 1702 596 2349 789 366 385 959 683 573 732 1450 750 706 451 839 246 2049 1128 1976];
% global random_lambda_limit = 50;
G = graph(start_nodes,target_nodes, weights);
plot(G,'EdgeLabel',G.Edges.Weight)

x = assign_wavelength(G, 'First Fit');

%displays the results in a formated output
for i = 1:length(x)
    path = cell2mat((x(i,1)));
    len = cell2mat((x(i,2)));
    lambda = cell2mat((x(i,3)));
    output = ['Path: ' , num2str(path), ' Len: ' , num2str(len), ' Lambda: ', num2str(lambda)];
    disp(output);
end

%main function that receives as input arguments a weighted graph and the
%wavelength assignment algorithm
function assigned_wavelengths = assign_wavelength(weighted_graph, algorithm)
count = 0; %keeps count of the amount of paths
path_array = {}; % cellarray that stores each path, and it's respective length and wavelenght
for i = 1:14 %fills the cellarray with the shortest paths between every 2 nodes
    for j = 1:14
        if(i<j)
            count = count + 1;
            [path, len] = shortestpath(weighted_graph, i, j);
            path_array(count,:) = {path, len, 1}; % by default, every path gets assigned wavelength 1
        end
    end
end
sorted_path_array = sortrows(path_array,2);  %sorts the paths by shortest length
switch(algorithm) % returns the chosen algorithm
    case 'First Fit'
        assigned_wavelengths = first_fit(sorted_path_array, count);
    case 'Most Used'
        assigned_wavelengths = most_used(sorted_path_array, count);
    case 'Random'
        assigned_wavelengths = random_lambda(sorted_path_array, count);
end



end

%function to assign wavelengths based on first fit algorithm. Receives as
%input arguments a Nx3 cell array with path, length and wavelength, and a
%count variable that defines the amount of paths
function assigned_first_fit = first_fit(sorted_path_array, count)
%for each path, it will check if it has links in common with previous paths.
%If it does, it will store the assgned lambdas of those paths on a vector
for i = 1:count
    current_path = cell2mat(sorted_path_array(i,1));
    used_lambdas = [];
    for j = 1:(length(current_path)-1)
        first_node = current_path(j);
        second_node = current_path(j+1);
        for k = 1:i-1
            comparable_path = cell2mat(sorted_path_array(k,1));
            for l = 1:length(comparable_path)-1
                break_var = 0;
                if (first_node == comparable_path(l) && second_node == comparable_path(l+1)) || (first_node == comparable_path(l+1) && second_node == comparable_path(l))
                    used_lambdas(end+1) = cell2mat(sorted_path_array(k,3));
                    break_var = 1;
                    break;
                end
                if break_var == 1
                    break;
                end
            end
        end
    end
    lambda = 1;
    
    %based on the vector with used lambdas, it will choose the first
    %ununsed one and assign it to this path.
    while(true)
        counter = 0;
        if ~isempty(used_lambdas)
            for j = 1:length(used_lambdas)
                if lambda == used_lambdas(j)
                    lambda = lambda + 1;
                    counter = 0;
                end
                counter = counter + 1;
            end
            if counter == length(used_lambdas)
                break
            end
        else
            break
        end
    end
    sorted_path_array(i,3) = num2cell(lambda);
end

assigned_first_fit = sorted_path_array;
end

%function to assign wavelengths based on random algorithm. Receives as
%input arguments a Nx3 cell array with path, length and wavelength, and a
%count variable that defines the amount of paths
function assigned_random = random_lambda(sorted_path_array, count)
%for each path, it will check if it has links in common with previous paths.
%If it does, it will store the assgned lambdas of those paths on a vector
for i = 1:count
    current_path = cell2mat(sorted_path_array(i,1));
    used_lambdas = [];
    for j = 1:(length(current_path)-1)
        first_node = current_path(j);
        second_node = current_path(j+1);
        for k = 1:i-1
            comparable_path = cell2mat(sorted_path_array(k,1));
            for l = 1:length(comparable_path)-1
                break_var = 0;
                if (first_node == comparable_path(l) && second_node == comparable_path(l+1)) || (first_node == comparable_path(l+1) && second_node == comparable_path(l))
                    used_lambdas(end+1) = cell2mat(sorted_path_array(k,3));
                    break_var = 1;
                    break;
                end
                if break_var == 1
                    break;
                end
            end
        end
    end
    lambda = randi([1,50]);
    while(true)
        counter = 0;
        if ~isempty(used_lambdas)
            for j = 1:length(used_lambdas)
                if lambda == used_lambdas(j)
                    lambda = randi([1,50]);
                    counter = 0;
                end
                counter = counter + 1;
            end
            if counter == length(used_lambdas)
                break
            end
        else
            break
        end
    end
    sorted_path_array(i,3) = num2cell(lambda);
end

assigned_random = sorted_path_array;
end

function assigned_most_used = most_used(sorted_path_array, count)
lambda_array = [];
for i = 1:50
    lambda_array(i,1) = i;
    lambda_array(i,2) = 0;
end
for i = 1:count
    current_path = cell2mat(sorted_path_array(i,1));
    used_lambdas = [];
    for j = 1:(length(current_path)-1)
        first_node = current_path(j);
        second_node = current_path(j+1);
        for k = 1:i-1
            comparable_path = cell2mat(sorted_path_array(k,1));
            for l = 1:length(comparable_path)-1
                break_var = 0;
                if (first_node == comparable_path(l) && second_node == comparable_path(l+1)) || (first_node == comparable_path(l+1) && second_node == comparable_path(l))
                    used_lambdas(end+1) = cell2mat(sorted_path_array(k,3));
                    break_var = 1;
                    break;
                end
                if break_var == 1
                    break;
                end
            end
        end
    end
    a = 1;
    lambda_counter = 1;
    while(true)
        counter = 0;
        if ~isempty(used_lambdas)
            for j = 1:length(used_lambdas)
                if a == used_lambdas(j)
                    a = lambda_array(lambda_counter,1);
                    lambda_counter = lambda_counter + 1;
                    counter = 0;
                end
                counter = counter + 1;
            end
            if counter == length(used_lambdas)
                break
            end
        else
            break
        end
        if lambda_array(1,2) == 0
            a = 1;
            lambda_array(1,2) = lambda_array(1,2) + 1;
        else
            a = lambda_array(lambda_counter,1);
            lambda_counter = lambda_counter + 1;
        end
    end
    lambda_array(lambda_counter,2) = lambda_array(lambda_counter,2) + 1;
    lambda_array = sortrows(lambda_array, -2);
    sorted_path_array(i,3) = num2cell(a);
    
    assigned_most_used = sorted_path_array;
end
end
