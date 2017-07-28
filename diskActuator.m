function [ inducedSpeed ] = diskActuator( airspeed, density, thrust, propellerDiameter )
% DISKACTUATOR Computes the induced velocity in the far field using the
% momenthum theory
%   The inputs are:
%    - airspeed: this is the speed at which the aircraft is moving [m/s]
%    - density: the density of the air [kg/m^3]
%    - thrust: the thrust required per propeller [N]
%    - propellerDiameter: the diameter of the propeller [m]
%
%   The output is:
%    - the induced velocity
% 
%   To derive this formula:
%   Thrust:  T = Area * dp
%   Area = pi*D^2/4
%   Mass flux:  mdot = rho*Area*(vo+v1)
%   1. Bernouilli
%    - Bernouilli at the infinity before (0) and just before the disk (1)
%      p0 + 1/2*rho*v0^2 = p1 + 1/2*rho*(v0+v1)^2
%    - Bernouilli at infinity after (2) and just after the disk (1)+dp
%      p0 + 1/2*rho*(v0+v2)^2 = p1 + dp + 1/2*rho*(v0+v1)^2
%    - we find:
%      dp = 1/2*rho*(2*v0*v2 + v2^2)
%   2. momenthum variation
%    - T = mdot*(v0+v2)-mdot*v0
%      T = rho*Area*(v0+v1)*v2
%      -> dp = rho*(v0+v1)*v2
%   3. comparing the 2 dp formulas
%     v2 = 2*v1
%   4. Thrust function of v2:
%     T = (pi*D^2)/4*1/2*rho*(2*v0*v2 + v2^2)
%     v2^2 + 2*v0*v2 - 8*T/(pi*rho*D^2) = 0
%     v2 = -v0 + sqrt(v0^2 + 8*T/(pi*rho*D^2))
%     

inducedSpeed = 0.5 * (-norm(airspeed) ...
    + sqrt(norm(airspeed)^2 + 8*thrust/(pi()*density*propellerDiameter^2)) );

end