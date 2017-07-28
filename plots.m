%% Plots

plot(y,chord)
title('Chord');

figure
plot(y,gamma)
title('Gamma');

figure
plot(y,alphai);
title('Induced angle of attack');

figure
plot(inducedVelocity(:,1))
hold on
plot(inducedVelocity(:,3))
title('Velocities induced by the propellers');

experimentalData = readFile('experimental4swirl.txt');
experimentalData(1,:) = experimentalData(1,:) * diameters/2;
figure
plot(y,cl);
hold on
plot(experimentalData(1,:), experimentalData(2,:), 'o');
title('Lift coefficient comparison');
