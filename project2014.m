close all;
clear all;
clc;
k_vector=[1 2 3 4 5 6 7 8 9];
for l=1:1:3         % loop ��� ���� ��� ������� ����� ��� �
    averages_k =[]; %���������� ����� ������� ������� ��� ���� �(������� 2)
    ga_k =[];       % ����������� � ��� ���� �
    gb_k = [];      % ����������� � ��� ���� � 
    for k=1:1:9     % loop ��� ���� ��� ������� ����� ��� �
        
%----------INITIALIZATIONS----------------%

ma=4;
mb=1;
state = 0;
arrivals_counter = 0;
total_counter = 0;
upper_chain = 1;
conversion_old = 0.0;   %��������� �� ��� ����� ��������� �� �������� - 
                        %���������� �� ����� ���� ��� ����� ���� �������
conversion_new = 100.0; %��������� �� ��� ����� ��������� �� �������� - 
                        %���������� �� ��� ���� ��� ����� ���� �������
arrivals_a = zeros([1,11]);
arrivals_ab = zeros([1,11]);
prob_arrival_a = zeros([1,11]);
prob_arrival_ab = zeros([1,11]);
averages_vector = [];
totalcounter_vector =[];

%--------SIMULATION && PLOTTING  -----------------------%


        while (abs(conversion_old - conversion_new) > 0.0001 ...
                        && (total_counter < 1000000)) %�������� ���������
            i = rand(1);   %��������� ������� �������
            %state
            %upper_chain
            if (state==0)  %��������� 0 - ���� ������������
                arrivals_counter=arrivals_counter+1;
                arrivals_a(state+1)=arrivals_a(state+1) + 1;
                state=state+1;
                upper_chain=1;
            elseif (state == 10)  %��������� 10 - ������ ���������
                if i < (l/(l+ma+mb))  %%afiksi
                    arrivals_counter = arrivals_counter +1;
                    arrivals_ab(state+1) = arrivals_ab(state+1) +1;
                elseif (k==9)  % ��� ��������� ��� k=9 � ��������� 10 �����
                               %������ ��������� ������ �� ������� 
                               %����������� ��� ��� �����������
                    if ((i<((l+mb)/(l+ma+mb))) && (i>=(l/(l+ma+mb)))) 
                        %irthe anaxwrisi apo ton b
                        state = state-1;
                        upper_chain=1;
                    else   %��������� ��� �
                        state = state-1;
                        upper_chain=0;
                    end
                else
                    state = state -1;    
                end
            elseif ((state<k+1) && (upper_chain==1) && (state~=0))  
                %��������� ���� ������� ��� ��������� 1-� ��� ���������� �
                if (i < l/(l+ma))    % �����
                    arrivals_counter = arrivals_counter + 1;
                    arrivals_a(state+1)=arrivals_a(state+1) + 1;
                    state = state+1;    
                else   %���������
                    state = state -1;
                end
                if (state == k+1)
                        upper_chain=0;
                end
                
            elseif ((state<=(k+1)) && (upper_chain==0) && (state~=0) ...
                    && (state~=1)) 
                % ��������� ���� ����������� ��� ��������� 2-�+1 ���� �����
                % ����������� ��� �� 2 ������������. ��� ��� ��������� 1��
                % �� ������� ������ ���������
                if (i< l/(l+ma+mb))
                    arrivals_counter = arrivals_counter + 1;
                    arrivals_ab(state+1) = arrivals_ab(state+1) +1;
                    state = state +1;
                elseif ((i>=(l/(l+ma+mb))) && (i<((ma+l)/(l+ma+mb)))) 
                    %anaxwrisi apo a
                    upper_chain = 0;
                    state = state -1;
                else %anaxwrisi apo b
                    upper_chain = 1;
                    state = state - 1;
                end
            elseif ((state == 1) && (upper_chain == 0)) 
                %��������� 1 - ����������� ��� �� ��� ������������
                if (i< l/(l+mb))  %�����
                    arrivals_counter = arrivals_counter + 1;
                    arrivals_ab(state+1)=arrivals_ab(state+1)+1;
                    state = state + 1;
                else   %��������� ���� ��� � - ��������� ���� ���� �������
                    state = state -1;
                    upper_chain=1;
                end    
            elseif ((state>k+1) && (upper_chain == 0))  
                %��������� > �+1 ����������� ��� �� ��� ������������
                if (i < l/(l+ma+mb))
                    arrivals_counter = arrivals_counter +1;
                    arrivals_ab(state+1) = arrivals_ab(state+1) +1;
                    state = state+1;
                else
                    state = state -1;
                end
            end
            total_counter = total_counter+1;
            if ((mod(total_counter,1000) == 0))
                conversion_old = conversion_new;
                conversion_new = 0;
                for iter = 1:1:11
                    prob_arrival_a(iter)=arrivals_a(iter)/arrivals_counter;  
                    %� ���������� �������� �� �� ������ ��� ������� ���� 
                    %iter ��������� ���� �� ������ ��� ��������� �������.
                    %������ ��� ��� �� �������
                    prob_arrival_ab(iter)=arrivals_ab(iter)/ ... 
                        arrivals_counter;
                    conversion_new = conversion_new + (iter-1)* ... 
                        (prob_arrival_a(iter) + prob_arrival_ab(iter));
                end

                 averages_vector=[averages_vector conversion_new]; 
                 %����������� ����� ����� ������� ��� ���� ������� 
                 totalcounter_vector = [totalcounter_vector total_counter]; 
                 %����������� "��������" �����������
            end            
        end
        l
        k
        totalcounter_vector 
        averages_k = [averages_k averages_vector(end)]; 
        figure();
        plot(totalcounter_vector,averages_vector);
        grid();
        title(['������ ������� �=',int2str(l),' k=',int2str(k)]);
        ylabel('����� ������� ������� ��� �������'); 
        xlabel('������ ����������� ������������');

        Pa = 1-(prob_arrival_a(1) + prob_arrival_ab(2)); 
        %���������� �� ���������� � � - 
        ga = Pa*ma; % ����������� �
        ga_k=[ga_k ga];
 		Pb=0; %���������� �� ���������� � �
        
        for j=2:1:11
            Pb = Pb+prob_arrival_ab(j);
        end
 		gb=Pb*mb;
        gb_k=[gb_k gb];
    end 
    averages_k
    ga_k
    gb_k
    g_ratio= ga_k./gb_k
    figure();
    plot(k_vector,averages_k);
    grid();
    title(['����� ������� ������� ���������� k ��� l=',int2str(l)]);
    ylabel('����� ������� ������� ��� ������� ���� �� ��������');
    xlabel('k');
    
    figure();
    plot(k_vector,ga_k);
    grid();
    title(['����������� � ���������� k ��� l=',int2str(l)]);
    ylabel('����������� ����������� �');
    xlabel('k');
    
    figure();
    plot(k_vector,gb_k);
    grid();
    title(['����������� � ���������� k ��� l=',int2str(l)]);
    ylabel('����������� ����������� �');
    xlabel('k');
    
    figure();
    plot(k_vector,g_ratio);
    grid();
    title(['����� ������������� ���������� k ��� l=',int2str(l)]);
    ylabel('����� ������������� ������������ �,�');
    xlabel('k');
end