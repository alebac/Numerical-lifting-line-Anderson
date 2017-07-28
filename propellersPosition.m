function [ propData ] = propellersPosition( hubPositions, ...
    diameters, k, wingspan, propellerRotationSpeed, airspeed, density, ...
    thrust )

% This function computes the vector of propellers radii position after
% position along the wingspan. This vector will be then used by the
% function induced_velocity_propeller to cumpute the induced velocities.
% The inputs are the vevctor of the poistion of the propellers hubs
% (hubPosition) and the vector of the propellers diameters (diameters).

    k = k+1;
    
    propData = zeros(k,3);
    radius = zeros(k,1);
    radius2 = zeros(k,1);
    inducedVelocity = zeros(k,1);
    rotationSpeed = zeros(k,1);
    
    w = size(hubPositions,1);
    if w == size(diameters,1)
        
        for i = 1:w
            propeller = int32( k * diameters(i)/wingspan);
            propellerHalf = int32( k * diameters(i) / (2*wingspan));
            hubPosition = int32( k * hubPositions(i)/wingspan);
            propellerRadius = diameters(i)/2;
            rad = radProp(propeller, propellerRadius);
            
            a = hubPosition - propellerHalf;
            b = a + propeller - 1;
            
            if a < 1 || b > k 
                error('Index out of bounds, try with bigger k');
            else
                radius(a:b) = rad;
                radius2(a:b) = 1;
                inducedVelocity(a:b) = diskActuator(airspeed, density, ...
                    thrust(i), diameters(i) );
                rotationSpeed(a:b) = propellerRotationSpeed(i);
            end
        end
    else
        error('Error. The vectors hubPositions and diameters vectors do not contain the same number of elements. They should be coloumn vectors containing respectively the positions of the propellers hubs and the diameter of each propeller.');            
    end
    
    propData(:,1) = radius;
    propData(:,2) = radius2;
    propData(:,3) = inducedVelocity;
    propData(:,4) = rotationSpeed;
  
end