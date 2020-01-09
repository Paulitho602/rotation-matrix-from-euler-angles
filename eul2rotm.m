function rotm = eul2rotm(eul, sequence)

%{
rotm = eul2rotm(eul) converts a set of Euler angles, eul, to the 
corresponding rotation matrix, rotm.
Default rotation is a three way rotation Z, Y, then X.
Rotation order can be changed. Also a change in the number of rotations,
twice or three times is possible.

Created by Dr. Paul Thomas 09.01.2020
%}
%% INPUT
%{
eul      -   Vector of euler angles. Size [3x1] recommended, but [1X3] also
             possible.
sequence -   order of rotations. Default is 'ZYX'. Two way rotation is also
             possible, such as 'XY', 'YZ', etc.
%}
%% OUTPUT
%{
rotm     -   Rotation matrix in the form [3x3] calculated from the euler
             angles
%}

%% CALCULATION

    % Look for the dimensions of eul and change them if eul is a column
    % rather than a row vector
    if (size(eul,1) ~= 3) && (size(eul,2) == 3)
        eul = eul';
    elseif (size(eul,1) ~= 3) && (size(eul,2) ~= 3)
        error('eul2rotm: %s', WBM.wbmErrorMsg.WRONG_VEC_DIM);
    end
    
    % Check if sequence exists and define default if sequence is not given
    if ~exist('sequence', 'var')
        % use the default axis sequence ...
        sequence = 'ZYX';
    end
    
    
% 1. Elementary rotation matrices
    RX = [1 0 0;0 cos(eul(1,1)) -sin(eul(1,1));0 sin(eul(1,1)) cos(eul(1,1))];
    
    RY = [cos(eul(2,1)) 0 sin(eul(2,1));0 1 0;-sin(eul(2,1)) 0 cos(eul(2,1))];
    
    RZ = [cos(eul(3,1)) -sin(eul(3,1)) 0;sin(eul(3,1)) cos(eul(3,1)) 0;0 0 1];
    
    % create table to calculate resulting rotation matrix
    A = table(RX,RY,RZ);
    
% 2. Calculation of the resulting rotation matrix in dependence of the 
% given sequence  

    % Preallocate the resulting Rotation matrix
    rotm = zeros(3,3);
 
    if size(sequence,2) == 3
        % 3 Rotations
        v1 = sequence(1);
        v2 = sequence(2);
        v3 = sequence(3);
        
        Rv1 = ['R' v1];
        Rv2 = ['R' v2];
        Rv3 = ['R' v3];
        
        rotm = A.(Rv1)*A.(Rv2)*A.(Rv3);
        
        
    elseif size(sequence,2) == 2
        % 2 Rotations
        v4 = sequence(1);
        v5 = sequence(2);
        
        Rv4 = ['R' v4];
        Rv5 = ['R' v5];
        
        rotm = A.(Rv4)*A.(Rv5);
        
    end
end