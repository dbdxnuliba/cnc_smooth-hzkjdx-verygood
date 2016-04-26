function feedLimit = FeedLimitCal(interpStepCurvature)

global chordErr;
global blockFeed;
global maxAcc;
global maxJerk;
global interpolationPeriod;

curvatureRadius = 1 / interpStepCurvature;  % ���ʰ뾶

chordLimitFeed = 2 * sqrt(curvatureRadius^2 - (curvatureRadius - chordErr)^2) / interpolationPeriod;
curvatureAlgorithmFeed = blockFeed / (interpStepCurvature + 1); % Vcbf
accLimitFeed = sqrt(maxAcc / interpStepCurvature);              % ���ٶ�Լ��
jerkLimitFeed = (maxJerk / interpStepCurvature^2) ^ (1 / 3);    % Ծ��Լ��

feedLimit = min([blockFeed, chordLimitFeed, curvatureAlgorithmFeed, accLimitFeed, jerkLimitFeed]);