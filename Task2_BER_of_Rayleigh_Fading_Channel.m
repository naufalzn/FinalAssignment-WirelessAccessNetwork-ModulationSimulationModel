close all;clear all;clc;
%Task 2 Jaringan Akses Nirkabel
%Created by : Naufal Zaidan Nabhan / 18119005

%% Initialization

numberbits = 10^5; %Number of bits 
fd = 30; %Doppler frequency
bitrate = 64000; %Bit rate
SNRdB=0:5:25; %Signal-to-noise ratio in dB
SNR=10.^(SNRdB/10); %Signal-to-noise ratio in linear
numbersimulation = 5; %Number of monte carlo simulations

%% Fading channel simulation

%Transmitter
datatx = randi([0,1],1,numberbits);
bpsk = 2*datatx-1;
%SImulation
for i=1:length(SNRdB)
    BERsim = 0;
    for k=1:numbersimulation %Monte carlo simulation 
         h = fading2(numberbits,fd, 1/bitrate); 
         n = 1/sqrt(2)*[randn(1,numberbits) + 1i*randn(1,numberbits)]; %White gaussian noise
         fadingchannel = bpsk.*h+10^(-SNRdB(i)/20)*n; %Fading channel
         %Receiver
         y=fadingchannel./h;
         datarx = real(y)>0; %Receiver decision
         error= biterr(datatx,datarx); %Counting error
         BERsim=BERsim+error/numberbits; %Counting BER
    end
    BERsimavg(i)=BERsim/numbersimulation; %Counting BER average from monte carlo simulation
end
    
BERth = (1/2)*(1-sqrt(SNR./(1+SNR))); %Counting BER from fading channel formula

%% BER Plot
semilogy (SNRdB, BERth, '-m<',"marker", "<", 'LineWidth', 2);
hold on;grid on;
semilogy (SNRdB, BERsimavg, '--b', "marker", "*", 'linewidth', 1.75);
legend("BER Theoretical","BER Simulated");
xlabel('Eb/Io (dB)') 
ylabel('Bit Error Rate')
title('BER Performance in Rayleigh Channel');
%}