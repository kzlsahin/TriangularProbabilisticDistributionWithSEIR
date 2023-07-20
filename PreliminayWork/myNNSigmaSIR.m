function [y1,xf1,xf2] = myNNSigmaSIR(x1,x2,xi1,xi2)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Auto-generated by MATLAB, 03-Jan-2021 02:31:09.
%
% [y1,xf1,xf2] = myNeuralNetworkFunction(x1,x2,xi1,xi2) takes these arguments:
%   x1 = 4xTS matrix, input #1 time N activeCases daily_deaths
%   x2 = 1xTS matrix, input #2 times steps
%   xi1 = 4x4 matrix, initial 4 delay states for input #1.
%   xi2 = 1x4 matrix, initial 4 delay states for input #2.
% and returns:
%   y1 = 1xTS matrix, output #1
%   xf1 = 4x4 matrix, final 4 delay states for input #1.
%   xf2 = 1x4 matrix, final 4 delay states for input #2.
% where TS is the number of timesteps.

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.keep = [1 3 4];
x1_step2.xoffset = [6;94;0];
x1_step2.gain = [0.0072992700729927;0.000275178866263071;0.222222222222222];
x1_step2.ymin = -1;

% Input 2
x2_step1.xoffset = 0.150289881452543;
x2_step1.gain = 2.44728631161895;
x2_step1.ymin = -1;

% Layer 1
b1 = [-1.5297559973313934467;1.316880387019391252;0.85378456031742622212;0.60093418070225501637;-0.14020664599940335648;-0.18029770010390414048;0.31304720413116687849;0.89477962334792993104;-1.3905001430074799273;-1.5954169761429444208];
IW1_1 = [0.45723646066494316731 -0.1741772893289526003 -0.58674864255391112611 -0.16506791630302811158 -0.10392246575401786757 0.20854545192742612869 -0.1569607289040893805 0.63801967057448683018 0.47520989274881186848 0.082699331498701608711 -0.53055032678052260753 -0.1911009874894172289;-0.5046294236478646722 -0.077312225462951161825 0.4932723021626226334 0.20480019864887025194 0.29819473592999712341 0.34651451252764575717 -0.5701292800310955311 -0.49789583891316879782 -0.30234739912616687141 -0.030578033333651416514 -0.30685746075548342438 -0.78079776305184245278;-0.170946217982240245 -0.42426039457405340105 0.42568902806832803476 -0.61768415224382644535 0.23571075467412408444 0.32640515532559150058 -0.28375480249564977164 0.18835793236761666503 0.56001033533791544361 0.34786184915669859929 0.15351777668064484073 -0.07779347152461946191;-0.05815311695744535686 0.19746931896438960075 0.25680922751773449519 -0.12326473702640795838 0.26563567603464754985 -0.029727994925245821572 -0.096688765265915410652 -0.34415964596557935273 0.30407942564882411984 -0.3115611660360130819 -0.42440186861007128671 0.12402434649552310231;0.51878499421020041193 -0.099066452633174609255 -0.3058555247411207656 -0.37636968264700421116 -0.59802606285867132563 -0.31825552437727228083 -0.089805407783738258609 0.20103532583552280455 -0.62903091590068094252 0.25451446164175894893 0.38216396713099232141 0.052017934274247279447;-0.40621172724107829088 -0.15646717600992060548 0.060825161740775263164 -0.3977402903911065879 -0.63455231215377005949 -0.64353185192341710863 0.09551259214415300236 0.45052194717227744825 -0.071479217470416092639 0.11873948071743062327 -0.28566602936804080803 -0.10546382937449222394;0.50553929183503598654 -0.049428501420966296231 -0.32550528595974709267 -0.41376920098854069741 -0.27600719929921679885 0.18013996480242874809 0.53584740585878909425 -0.56174356352754950539 0.22275342770054873398 -0.6050768326172581979 0.54437633063308055181 -0.1411148158823760379;0.18429319957424253329 -0.44122432776959719103 0.71476265147462736405 -0.22566236004315959329 0.041495851645145145903 0.37188298243063094839 -0.049792354242862435498 -0.47168643815084626558 0.79408968215415509651 -0.68203206746718136877 -0.42728906967104463011 0.10921230601813111671;-0.18918270030170930562 -0.34642366606238150784 0.23901701503282479777 -0.61839881905699733977 0.27863129837793859656 -0.26402213811650487862 0.67811427622822428862 -0.35158469697299982171 -0.50390202498043845658 0.3406854099864322083 0.43001203894365819247 0.30359434948726754522;-0.52741751789446056353 0.22605463588088997584 0.56032119630890919737 0.21366427920284297715 -0.17946787515829895621 -0.72662279554396158598 0.28476926179152134422 0.29084276583250939785 -0.16055342336863426267 -0.014032438403426704746 -0.57036197970608093488 0.23381870198749532541];
IW1_2 = [0.89745042232869043364 -0.18373937415693730735 -0.23260079865246405251 0.42723251138092488421;-0.42851506307828118869 0.33297861464778405471 -0.27458200563289697493 0.086880353831628023831;0.34064184941665676121 -0.3634897588982587413 -0.58954073715496480013 0.64256903857547031933;0.06519108232900228117 0.60800903328720257157 0.74543218319471760136 -0.64319193132318230877;-0.23936386504150478083 -0.049173764262496200139 0.17239663284095557705 -0.54156094525473419399;-0.16004285775446297491 -0.35193856868372319635 0.072552258670352587355 -0.30195715809765499849;-0.80451016002770847635 0.18847162128732200537 0.025221258310186830953 -0.4592392572907147974;0.025448993057384693833 0.079056416373597088176 0.0046494872715344155029 -0.30157919329337135039;-0.17126674101152900009 0.021671371902581084562 0.219107390310051664 0.029251756246902280156;0.61009983005489698549 0.66824578862032357751 0.14156018565707942369 -0.22825494495356515867];

% Layer 2
b2 = 0.13274980647236014897;
LW2_1 = [0.43794385442717542745 0.070847624803256320503 0.30476664535675518364 0.31834105224449604776 0.68450116315562259395 -0.25536489574034093586 -0.60031336949012015225 0.10656755152170961642 -0.52791028565025632791 0.12800716160910502461];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = 2.44728631161895;
y1_step1.xoffset = 0.150289881452543;

% ===== SIMULATION ========

% Dimensions
TS = size(x1,2); % timesteps

% Input 1 Delay States
xd1 = removeconstantrows_apply(xi1,x1_step1);
xd1 = mapminmax_apply(xd1,x1_step2);
xd1 = [xd1 zeros(3,1)];

% Input 2 Delay States
xd2 = mapminmax_apply(xi2,x2_step1);
xd2 = [xd2 zeros(1,1)];

% Allocate Outputs
y1 = zeros(1,TS);

% Time loop
for ts=1:TS
    
    % Rotating delay state position
    xdts = mod(ts+3,5)+1;
    
    % Input 1
    temp = removeconstantrows_apply(x1(:,ts),x1_step1);
    xd1(:,xdts) = mapminmax_apply(temp,x1_step2);
    
    % Input 2
    xd2(:,xdts) = mapminmax_apply(x2(:,ts),x2_step1);
    
    % Layer 1
    tapdelay1 = reshape(xd1(:,mod(xdts-[1 2 3 4]-1,5)+1),12,1);
    tapdelay2 = reshape(xd2(:,mod(xdts-[1 2 3 4]-1,5)+1),4,1);
    a1 = tansig_apply(b1 + IW1_1*tapdelay1 + IW1_2*tapdelay2);
    
    % Layer 2
    a2 = b2 + LW2_1*a1;
    
    % Output 1
    y1(:,ts) = mapminmax_reverse(a2,y1_step1);
end

% Final delay states
finalxts = TS+(1: 4);
xits = finalxts(finalxts<=4);
xts = finalxts(finalxts>4)-4;
xf1 = [xi1(:,xits) x1(:,xts)];
xf2 = [xi2(:,xits) x2(:,xts)];
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings)
y = bsxfun(@minus,x,settings.xoffset);
y = bsxfun(@times,y,settings.gain);
y = bsxfun(@plus,y,settings.ymin);
end

% Remove Constants Input Processing Function
function y = removeconstantrows_apply(x,settings)
y = x(settings.keep,:);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n,~)
a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings)
x = bsxfun(@minus,y,settings.ymin);
x = bsxfun(@rdivide,x,settings.gain);
x = bsxfun(@plus,x,settings.xoffset);
end