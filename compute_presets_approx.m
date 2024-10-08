function presets = compute_presets_approx(target,W,U,X,A_hat,B_hat)

% Author:       Mehran Attar
% Written:      08-March-2023
% Last update:
% Last revision:---
% This function computes augmentd ROSC sets of $(x-u)$
      
%------------- BEGIN CODE --------------

H_x = X.A;
h_x = X.b;
H_u = U.A;
h_u = U.b;
H = target.A;
h = target.b;

%% compute h_tilde
w = sdpvar(W.Dim,1);
% 
global h_tilde
const1 = w<=[W.b(1);W.b(1)];
const2 = w>=[-W.b(1);-W.b(1)];
const = const1 + const2;

opt = sdpsettings('verbose',0,'debug',1);
for i=1:size(H,1)
    obj = h(i,:) - H(i,:)*w;
    diagnostics=optimize(const,obj,opt);
    w_value = value(w);
    h_tilde(i) = h(i,:) - H(i,:)*value(w);
    
end
%% compute augmented ROSC sets
global A_hat
global B_hat

for j=1:size(A_hat,2)
    presets{j} = Polyhedron([H_x zeros(4,2);
        target.A*A_hat{j} target.A*B_hat{j};
        zeros(4,2) H_u],[h_x;h_tilde';h_u]);
end

% % 
%     presets = Polyhedron([H_x zeros(4,2);
%         target.A*A_hat target.A*B_hat;
%         zeros(4,2) H_u],[h_x;h_tilde';h_u]);

end

%------------- END CODE --------------