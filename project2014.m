close all;
clear all;
clc;
k_vector=[1 2 3 4 5 6 7 8 9];
for l=1:1:3         % loop για όλες τις πιθανές τιμές του λ
    averages_k =[]; %αποθηκευση μεσου αριθμου πελατων για καθε κ(ερώτημα 2)
    ga_k =[];       % ρυθμαπόδοση α για κάθε κ
    gb_k = [];      % ρυθμαπόδοση β για κάθε κ 
    for k=1:1:9     % loop για όλες τις πιθανές τιμές του κ
        
%----------INITIALIZATIONS----------------%

ma=4;
mb=1;
state = 0;
arrivals_counter = 0;
total_counter = 0;
upper_chain = 1;
conversion_old = 0.0;   %μεταβλητή με την οποία ελέγχουμε τη συγκλιση - 
                        %αποθηκευει τη πάλια τιμή του μέσου όρου πελατών
conversion_new = 100.0; %μεταβλητή με την οποία ελέγχουμε τη συγκλιση - 
                        %αποθηκευει τη νέα τιμή του μέσου όρου πελατών
arrivals_a = zeros([1,11]);
arrivals_ab = zeros([1,11]);
prob_arrival_a = zeros([1,11]);
prob_arrival_ab = zeros([1,11]);
averages_vector = [];
totalcounter_vector =[];

%--------SIMULATION && PLOTTING  -----------------------%


        while (abs(conversion_old - conversion_new) > 0.0001 ...
                        && (total_counter < 1000000)) %κριτήρια σύγκλισης
            i = rand(1);   %γεννήτρια τυχαίων αριθμών
            %state
            %upper_chain
            if (state==0)  %Κατάσταση 0 - αρχή διαγράμματος
                arrivals_counter=arrivals_counter+1;
                arrivals_a(state+1)=arrivals_a(state+1) + 1;
                state=state+1;
                upper_chain=1;
            elseif (state == 10)  %Κατάσταση 10 - τελική κατάσταση
                if i < (l/(l+ma+mb))  %%afiksi
                    arrivals_counter = arrivals_counter +1;
                    arrivals_ab(state+1) = arrivals_ab(state+1) +1;
                elseif (k==9)  % Στη περίπτωση που k=9 η κατάσταση 10 είναι
                               %οριακή κατάσταση πρέπει να πάρουμε 
                               %περιπτώσεις για τις αναχωρήσεις
                    if ((i<((l+mb)/(l+ma+mb))) && (i>=(l/(l+ma+mb)))) 
                        %irthe anaxwrisi apo ton b
                        state = state-1;
                        upper_chain=1;
                    else   %αναχώρηση από α
                        state = state-1;
                        upper_chain=0;
                    end
                else
                    state = state -1;    
                end
            elseif ((state<k+1) && (upper_chain==1) && (state~=0))  
                %Περίπτωση οπου είμαστε στη κατασταση 1-κ και εξυπηρετει α
                if (i < l/(l+ma))    % Αφιξη
                    arrivals_counter = arrivals_counter + 1;
                    arrivals_a(state+1)=arrivals_a(state+1) + 1;
                    state = state+1;    
                else   %αναχώρηση
                    state = state -1;
                end
                if (state == k+1)
                        upper_chain=0;
                end
                
            elseif ((state<=(k+1)) && (upper_chain==0) && (state~=0) ...
                    && (state~=1)) 
                % Περίπτωση οπου βρισκόμαστε στη κατάσταση 2-Κ+1 κάτω κλάδο
                % λειτουργουν και οι 2 εξυπηρετητες. Για την κατασταση 1ΑΒ
                % θα πάρουμε ειδικη περίπτωση
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
                %Κατάσταση 1 - λειτουργούν και οι δυο εξυπηρετητές
                if (i< l/(l+mb))  %αφιξη
                    arrivals_counter = arrivals_counter + 1;
                    arrivals_ab(state+1)=arrivals_ab(state+1)+1;
                    state = state + 1;
                else   %αναχώρηση μόνο από β - επιστροφή στην πανω αλυσιδα
                    state = state -1;
                    upper_chain=1;
                end    
            elseif ((state>k+1) && (upper_chain == 0))  
                %Κατάσταση > κ+1 λειτουργουν και οι δυο εξυπηρετητες
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
                    %Η πιθανότητα ορίζεται ώς το πληθος των αφιξεων στην 
                    %iter κατάσταση προς το πληθος των συνολικών αφιξεων.
                    %Ομοιως και για τα επόμενα
                    prob_arrival_ab(iter)=arrivals_ab(iter)/ ... 
                        arrivals_counter;
                    conversion_new = conversion_new + (iter-1)* ... 
                        (prob_arrival_a(iter) + prob_arrival_ab(iter));
                end

                 averages_vector=[averages_vector conversion_new]; 
                 %Υπολογισμός μεσων τιμών πελατών για κάθε χιλιάδα 
                 totalcounter_vector = [totalcounter_vector total_counter]; 
                 %Υπολογισμός "χιλιάδων" επαναλήψεων
            end            
        end
        l
        k
        totalcounter_vector 
        averages_k = [averages_k averages_vector(end)]; 
        figure();
        plot(totalcounter_vector,averages_vector);
        grid();
        title(['Ρυθμός αφίξεων λ=',int2str(l),' k=',int2str(k)]);
        ylabel('Μέσος αριθμός πελατών στο σύστημα'); 
        xlabel('Πλήθος επαναλήψεων προσομοίωσης');

        Pa = 1-(prob_arrival_a(1) + prob_arrival_ab(2)); 
        %πιθανότητα να εξυπηρετεί ο Α - 
        ga = Pa*ma; % ρυθμαπόδοση Α
        ga_k=[ga_k ga];
 		Pb=0; %πιθανότητα να εξυπηρετεί ο Β
        
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
    title(['Μέσος αριθμός πελατών συναρτήσει k για l=',int2str(l)]);
    ylabel('Μέσος αριθμός πελατών στο σύστημα μετά τη σύγκλιση');
    xlabel('k');
    
    figure();
    plot(k_vector,ga_k);
    grid();
    title(['ρυθμαπόδοση α συναρτήσει k για l=',int2str(l)]);
    ylabel('Ρυθμαπόδοση δρομολογητή α');
    xlabel('k');
    
    figure();
    plot(k_vector,gb_k);
    grid();
    title(['Ρυθμαπόδοση β συναρτήσει k για l=',int2str(l)]);
    ylabel('Ρυθμαπόδοση δρομολογητή β');
    xlabel('k');
    
    figure();
    plot(k_vector,g_ratio);
    grid();
    title(['Λόγος ρυθμαποδόσεων συναρτήσει k για l=',int2str(l)]);
    ylabel('Λόγος ρυθμαποδόσεων δρομολογητών α,β');
    xlabel('k');
end