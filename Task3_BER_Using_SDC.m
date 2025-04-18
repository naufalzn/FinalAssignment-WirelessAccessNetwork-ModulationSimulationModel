close all;clear all;clc;
%Task 3 Jaringan Akses Nirkabel
%Created by : Naufal Zaidan Nabhan / 18119005

%% Initialization

numberbits = 10^5; %Number bits
SNRdB=0:5:25; %Signal-to-noise ratio in dB
SNR=10.^(SNRdB/10); %Signal-to-noise ratio in linear
numbersimulation = 5; %Number of monte carlo simulations
bitrate = 64000; %Bit rate
fd = [15 30 180]; %Droppler frequency

%% Mitigation using SDC

%Transmitter
datatx = randi([0,1],1,numberbits);
bpsk = 2*datatx-1;
%Simulation
for i=1:length(SNRdB)
    for l=1:length(fd) %Different doppler frequency
        BER = 0;
        for k=1:numbersimulation %Monte carlo simulation 
            h1 (l,:)= fading2(numberbits, fd(l), 1/bitrate);
            h2 (l,:)= fading2(numberbits, fd(l), 1/bitrate);
            n1 = 1/sqrt(2)*[randn(1,numberbits) + 1i*randn(1,numberbits)]; %White gaussian noise
            n2 = 1/sqrt(2)*[randn(1,numberbits) + 1i*randn(1,numberbits)]; %White gaussian noise
            fadingchannel1(l,:) = bpsk.*h1(l,:)+10^(-SNRdB(i)/20)*n1; %Fading channel
            fadingchannel2(l,:) = bpsk.*h2(l,:)+10^(-SNRdB(i)/20)*n2; %Fading channel
            for r=1:numberbits %Selection diversity combining
                if (abs(fadingchannel1(l,r))>=abs(fadingchannel2(l,r)))
                    y1(l,r) = fadingchannel1(l,r);
                    y2(l,r)= fadingchannel1(l,r)/h1(l,r);
                else 
                    y1(l,r) = fadingchannel2(l,r);
                    y2(l,r) = fadingchannel2(l,r)/h2(l,r);
                end
            end
            %Receiver
            datarx(l,:) = real(y2(l,:))>0; %Receiver decision
            error(l)= biterr(datatx,datarx(l,:)); %Counting error
            BER=BER+error(l)/numberbits; %Counting BER
        end
        BERsim(l,i)=BER/numbersimulation; %Counting BER average from monte carlo simulation
    end

end

ber_fad_theory = (1/2)*(1-sqrt(SNR./(1+SNR))); %Counting BER from fading channel formula

%% BER Plot
figure;hold on;grid on;
semilogy (SNRdB, ber_fad_theory,'-m<',"marker", "<", 'LineWidth', 2);
semilogy (SNRdB, BERsim(1,:),'--g', "marker", "*", 'linewidth', 1.75);
semilogy (SNRdB, BERsim(2,:),'--b', "marker", "*", 'linewidth', 1.75);
semilogy (SNRdB, BERsim(3,:),'--r', "marker", "*", 'linewidth', 1.75);
legend("BER Theoretical","BER Simulated Fd 15","BER Simulated Fd 30","BER Simulated Fd 180");
xlabel('Eb/Io (dB)') 
ylabel('Bit Error Rate')
title('BER Performance of Rayleigh Channel Using SDC');

%% Power plot

%SDC Doppler frequency 15 Hz
figure; hold on;grid on;
t = [1:10:numberbits/2]./bitrate;
plot(t, 20*log10(abs(fadingchannel1(1,1:10:numberbits/2))), 'r--', 'linewidth', 1.5);
plot(t, 20*log10(abs(fadingchannel2(1,1:10:numberbits/2))), 'b--', 'linewidth', 1.5);
plot(t, 20*log10(abs(y1(1,1:10:numberbits/2))), 'k', 'linewidth', 1.75); hold off;
h = legend('Antena 1', 'Antena 2', 'SDC', 'location', 'SouthEast');
xlabel('Time (s)');
ylabel('Received Signal Level (dB)');
title('SDC Doppler frequency 15 Hz');

%SDC Doppler frequency 30 Hz
figure; hold on;grid on;
t = [1:10:numberbits/2]./bitrate;
plot(t, 20*log10(abs(fadingchannel1(2,1:10:numberbits/2))), 'r--', 'linewidth', 1.5);
plot(t, 20*log10(abs(fadingchannel2(2,1:10:numberbits/2))), 'b--', 'linewidth', 1.5);
plot(t, 20*log10(abs(y1(2,1:10:numberbits/2))), 'k', 'linewidth', 1.75); hold off;
h = legend('Antena 1', 'Antena 2', 'SDC', 'location', 'SouthEast');
xlabel('Time (s)');
ylabel('Received Signal Level (dB)');
title('SDC Doppler frequency 30 Hz');

%SDC Doppler frequency 180 Hz
figure; hold on;grid on;
t = [1:10:numberbits/2]./bitrate;
plot(t, 20*log10(abs(fadingchannel1(3,1:10:numberbits/2))), 'r--', 'linewidth', 1.5);
plot(t, 20*log10(abs(fadingchannel2(3,1:10:numberbits/2))), 'b--', 'linewidth', 1.5);
plot(t, 20*log10(abs(y1(3,1:10:numberbits/2))), 'k', 'linewidth', 1.75); hold off;
h = legend('Antena 1', 'Antena 2', 'SDC', 'location', 'SouthEast');
xlabel('Time (s)');
ylabel('Received Signal Level (dB)');
title('SDC Doppler frequency 180 Hz');

