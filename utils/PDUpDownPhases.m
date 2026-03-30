% Adapted by SDL 23.02.2026 from ts_EyePD for 2P rig
% PDDat already interpolated to twoPFrameTime


function [upPhases, downPhases] = PDUpDownPhases(PDDat,options)
if ~isfield(options,'stim_dur')
    options.stim_dur = 0.25;
    warning('Using default options.stim_dur of 0.25s')
end

% Gets the photodiode timestamps as recorded from the bonsai
% program
% AP 23/10/19
sampleRate = options.TwoPSampleRate;

%%%%%%%
% This for cases when the monitor was set at 100% brightness, thus
% no pulse width modulation
thresh_pos = 20;
thresh_neg = 20;
ttlind_up = find(PDDat>thresh_pos);
ttlind_down = find(PDDat<thresh_neg);

% If user specified different thresholds, check those
if isfield(options,'Eye_pD_thresholds') && ~isempty(options.Eye_pD_thresholds)
    thresh_neg = options.Eye_pD_thresholds(1);
    thresh_pos = options.Eye_pD_thresholds(2);
    ttlind_up_2 = find(PDDat>thresh_pos);
    ttlind_down_2 = find(PDDat<thresh_neg);

    % Check to see if using new thresholds works
    if ~isempty(ttlind_up_2)
        ttlind_up = ttlind_up_2;
        ttlind_down = ttlind_down_2;
    else % Use the default thresholds if it doesnt
        thresh_pos = 20;
        thresh_neg =-20;
        warning('Using default thresh_pos and thresh_neg for Eye')
    end
end

% If havent been able to find anything, return nicely
if isempty(ttlind_up)
    upPhases = [];
    downPhases = [];
    blockstarts = [];
    warning('No photodiode upswings detected')
    return
end

%%%%%%%%
% Find upphases (white squares)
ttl_diff = diff(ttlind_up);
if options.stim_dur < 1 % with very short stimuli the options.stim_dur*sampleRate/3 strategy does not work SDL 04/06/2025
    ttlind2 = find(ttl_diff > mean(ttl_diff));
else ttlind2 = find(ttl_diff > options.stim_dur*sampleRate/3);  % Find peaks that have a distance at least 1/3 of the stimulus duration
end
if ttlind_up(1)==1 % Sometimes the photodiode is set to 1 from the beginning. Not sure why.
    upPhases = [ttlind_up(ttlind2+1)];
else
    upPhases = [ttlind_up(1); ttlind_up(ttlind2+1)];
end

% check that it is indeead a change in threshold and not
% some random peak by checking that the photodiode is still up
% after 1/3 the duration of the stimulus
upP1 = upPhases+round(options.stim_dur*sampleRate/3);

% If the recording ended slightly early, this may not work
try
    tp1 = find(PDDat(upP1)<thresh_pos);
    upPhases(tp1) = [];
catch
    ;
end

%%%%%
% Find down phases (goes to black)
ttl_diff = diff(ttlind_down);
if options.stim_dur < 1 % with very short stimuli the options.stim_dur*sampleRate/3 strategy does not work SDL 04/06/2025
    ttlind2 = find(ttl_diff > mean(ttl_diff));
else ttlind2 = find(ttl_diff > options.stim_dur*sampleRate/3);
end

if isempty(ttlind2)
    downPhases = [];
    return
else
    if ttlind_down(1)==1
        downPhases = [ttlind_down(ttlind2+1)];
    else
        downPhases = [ttlind_down(1); ttlind_down(ttlind2+1)];
    end
end

% check that it is indeead a change in threshold and not
% some random peak by checking that the photodiode is still
% down after 1/3, half and 2/3 the duration of the stimulus
downP1 = downPhases+round(options.stim_dur*sampleRate/3);
downP2 = downPhases+round(options.stim_dur*sampleRate/2);
downP3 = downPhases+round(options.stim_dur*sampleRate*2/3);

% If the recording ended slightly early, this may not work
try
    tp1 = find(PDDat(downP1)>thresh_neg);
    tp2 = find(PDDat(downP2)>thresh_neg);
    tp3 = find(PDDat(downP3)>thresh_neg);
    downPhases(union(tp1,union(tp2,tp3))) = [];
catch
    ;
end


