function [ rad ] = radProp( propeller, propellerRadius )

% This function creates the vector of propeller dimension to be inserted in
% the total vector of radius in the function propellersRadius.

rad = zeros(propeller,1);
for j = 1:propeller
    n = double(j);
    n = n - 0.5;  
    % This subtraction is required becacuse the value is at the center of 
    % the segment of the lifting line 
    prop = double(propeller);
    m = n / prop;
    m = 2*m - 1;
    rad(j) = m*propellerRadius;
end

end