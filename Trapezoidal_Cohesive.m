clear all; close all; clc

%% inputs
Slope=1000; % Stiffness
Strength=0.1; % interfacial strength
Eng=0.005; % Fracture energy
Ratio=0.3; % Trapezoid shape related ratio

%% Calcilation of 3 dels (separation)

dp=[]; ds=[]; Dp=[]; Ds=[]; D=[]; ss=[];

c=Slope;
s=Strength;
Gc=Eng;
r=Ratio;
d1=s/c;
d3=2*Gc/(s*(1+r));
d2=d1+r*d3;

%% sampling of separation

res=50; % how many points

dp=linspace(d1,d2,res); % del1 to del2 refer to article: [1] Islam, M. S., & Alfredsson, K. S. (2019). Peeling of metal foil from a compliant substrate. The journal of adhesion, 1-32.

dps=linspace(dp(1),dp(2),res); % for smooth transition from del1 to del2

ds=linspace(d2,d3,res); % del2 to del3

dss=linspace(ds(1),ds(2),res);  % for smooth transition from del2 to del3

%% calculating damage variable values

DD=@(disp) 1-(s/(c*disp)); %Damage variable for del1 to del2 refer to article: [1]

for j=1:length(dp)
    Dp(j)=DD(dp(j)); %Damage variable value between del1 to del2
end

for j=1:length(dps)
    Dps(j)=DD(dps(j)); %Damage variable value at the transition between del1 to del2
end

DD=@(disp) 1-((s/(c*disp)))*(d3-disp)/(d3-d2); %Damage variable for del2 to del3 refer to article: [1]

for j=1:length(ds)
    Ds(j)=DD(ds(j)); %Damage variable value between del2 to del3
end

for j=1:length(dss)
    Dss(j)=DD(dss(j)); %Damage variable value at the transition between del2 to del3
end

Ds(end)=1; % Make sure the last damage value is 1

disp=[dps(1:end-1),dp(2:end-1),dss(3:end-1),ds(2:end)]'; % collect all separation
D=[Dps(1:end-1),Dp(2:end-1),Dss(3:end-1),Ds(2:end)]';  % collect all damage values

disp_aba=disp-disp(1);

aba_table=[D,disp_aba]


%% For plotting
di=linspace(0,d1,res); % Separation before damage initiation
Di=zeros(1,length(di));  % Damage before damage initiation
disp=[di';disp]; % Collect all data
D=[Di';D];
sig=(1-D).*c.*disp; % Calculate traction

figure (1)
plot(disp,sig,'-.r') % Plot traction-separation law 
