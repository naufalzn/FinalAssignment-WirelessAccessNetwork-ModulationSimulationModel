close all;clear all;clc;
%Task 1 Jaringan Akses Nirkabel
%Created by : Naufal Zaidan Nabhan / 18119005

%% Initialization

numberbits = 10^5; %Number of bits  
number_simulation = 5; %Number of monte carlo simulations
SNRdB=0:2:8; %Signal-to-noise ratio in dB
SNR=10.^(SNRdB/10); %Signal-to-noise ratio in linear

%% AWGN channel simulation

%Transmitter
datatx = randi([0,1],1,numberbits); %Generate bits
bpsk = 2*datatx-1; %BPSK modulation
%Simulation
for i=1:length(SNR)
    BERsim = 0; 
    for j=1:number_simulation %Monte carlo simulation
        N = sqrt(0.5*1/SNR(i))*randn(1,numberbits); %White gaussian noise
        y = bpsk+N;
        %Receiver
        datarx=real(y)>0; %Receiver decision
        t= biterr (datatx,datarx); %Counting bit error
        BERsim= BERsim+t/numberbits; %Counting BER
    end
    BERsimavg (i)= BERsim/number_simulation; %Counting BER average from monte carlo simulation
end

BERth = 0.5 * erfc(sqrt(SNR)); %Counting BER from AWGN channel formula

%% BER Plot
semilogy (SNRdB, BERth, '-m<',"marker", "<", 'LineWidth', 2);
hold on;grid on;
semilogy (SNRdB, BERsimavg, '--b', "marker", "*", 'linewidth', 1.75);
legend("BER Theoretical","BER Simulated");
xlabel('Eb/Io (dB)') 
ylabel('Bit Error Rate')
title('BER Performance in AWGN Channel');
