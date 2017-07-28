clear all
close all
clc

%% Input data
k = 200;
iterations = 250;
relaxationFactor = 0.05;

rootChord = 0.2;
taperRatio = 1;
wingspan = 0.8;
airspeed = [30 0 0];
density = 1.225;                % kg/m^3

alphaFly = 4; 
twist = 0;

alpha0lift = 0;
alphaRad = alphaFly * pi/180;
alpha0liftRad = alpha0lift * pi/180;
clalpha = 5.73; %2*pi;

%% Propellers
hubPositions = 0.4;
diameters = 0.15;
thrust = 5;
rpm = 25400;                                   % rounds per minute
propellerRotationSpeed = rpm/60 * 2*pi;         % radians per second

spinnerRadius = 0.1 * max(diameters);

%% ANDERSON %%

% Wing twist
clear alpha;
alphaTwist = abs((0:k) / k - 1/2)*2 * twist;
alphaTwist = alphaTwist';
alpha = alphaFly + alphaTwist;

%% Propellers
propData = propellersPosition(hubPositions, diameters, k, wingspan, ...
    propellerRotationSpeed, airspeed, density, thrust);
inducedVelocity = induced_velocity_propeller(propData, airspeed, ...
    spinnerRadius);

Vrel = ones(k+1,1)*airspeed;
Vrel = Vrel + inducedVelocity;
normVtot = zeros(k+1,1);
for i = 1:k+1
    normVtot(i) = norm(Vrel(i,:));
end

alphaSwirl = atan( Vrel(:,3) ./ Vrel(:,1) );

%% 1. Meshing
station = 0:k;
dy = wingspan/k;
y = station'*dy - wingspan/2;

% chord = rootChord * sqrt(1-(2*y/wingspan).^2);
chord = ones(k+1,1) * rootChord;
% chord = rootChord - 2*abs(y)/wingspan * (1-taperRatio)*rootChord;
% surface = pi*wingspan*rootChord/4;
surface = trapz(y,chord);

%% 2. Assume Gamma
gamma = 1 * sqrt(1-(2*y/wingspan).^2);

DgammaDy = zeros(k+1,1);
I = zeros(k+1,1);
f = zeros(k+1);
Error = zeros(iterations,1);

for i = 1:iterations
%% 3. Compute induced angle of attack
% DgammaDy(1:end-1) = diff(gamma)/dy;
% DgammaDy(end) = DgammaDy(end-1);

for t = 1:k/2
    DgammaDy(t) = (gamma(t+1) - gamma(t)) / dy;
end
DgammaDy(k/2+1) = 0;
for t = k/2+2 : k+1
    DgammaDy(t) = (gamma(t) - gamma(t-1)) / dy;
end

% Calculation of the integral
    for n=1:k+1
        for m=1:k+1
            if m == n
                f(n,m) = 0;
            else
                f(n,m) = DgammaDy(m)/(y(n)-y(m));
            end
        end
        I(n) = trapz(y,f(n,:));
    end   
    
 alphaiRad = I ./ (4*pi*normVtot);
 
 %% 4. Commpute alpha effective
 alphaEff = alpha*pi/180 - alphaiRad + alphaSwirl;  % minus sign here is to have the same 
                                                % rotation as Phillips method

 %% 5. Compute cl
 cl = 2*pi*(alphaEff - alpha0liftRad);
 
 %% 6. New lift distribution
 gammaNew = 1/2 * normVtot .* chord .* cl;
 gammaNew(1) = 0;
 gammaNew(end) = 0;
 Error(i) = sum(gammaNew - gamma);
  
 %% 7. Gamma update
 gamma = gamma + relaxationFactor*(gammaNew - gamma);
 end

%% 10. Last computations
CL = 2 / (norm(airspeed)*surface) * trapz(y,gamma);
CDi = 2 / (norm(airspeed)*surface) * trapz(y,gamma.*alphaiRad);
AR = wingspan^2 / surface;
e = CL^2/(pi*AR*CDi);

alphai = alphaiRad*180/pi;

%% Plots
plots
