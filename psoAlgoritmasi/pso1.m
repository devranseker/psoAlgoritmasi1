clc;
clear;
close all;

%% Problem tanımı
maliyetfunction = @(x) sphere(x);

nvar = 5;
varmin = -10;
varmax = 10;
varsize = [1 nvar];

%% PSO Parametreleri
maxit = 100;
npop = 30;
c1 = 2;
c2 = 2;
w = 0.8;

%% Başlatma
pozisyon = zeros(npop, nvar); % npop parçacık, her biri nvar boyutunda
maliyet = zeros(1, npop);
best_pozisyon = zeros(npop, nvar);
best_maliyet = inf(1, npop);
velocity = zeros(npop, nvar);

gbest_maliyet = inf;
gbest_pozisyon = zeros(1, nvar);

% Çözümlerimizi kaydedelim
bestmaliyet = zeros(maxit, 1);

% Başlangıç pozisyonları ve maliyetleri hesapla
for i = 1:npop
    pozisyon(i, :) = unifrnd(varmin, varmax, varsize);
    maliyet(i) = maliyetfunction(pozisyon(i, :));

    best_pozisyon(i, :) = pozisyon(i, :);
    best_maliyet(i) = maliyet(i);

    if maliyet(i) < gbest_maliyet
        gbest_maliyet = maliyet(i);
        gbest_pozisyon = pozisyon(i, :);
    end
end

% PSO ana döngüsü
for it = 1:maxit
    % Hızları güncelle
    for i = 1:npop
        velocity(i, :) = w * velocity(i, :) + c1 * rand * (best_pozisyon(i, :) - pozisyon(i, :)) ...
            + c2 * rand * (gbest_pozisyon - pozisyon(i, :));
    end

    % Pozisyonları güncelle
    pozisyon = pozisyon + velocity;

    for i = 1:npop
        maliyet(i) = maliyetfunction(pozisyon(i, :));

        % Eğer parçacığın şu andaki maliyeti, en iyi bilinen maliyetinden daha iyiyse,
        if maliyet(i) < best_maliyet(i)
            % Parçacığın en iyi bilinen maliyetini güncelle
            best_maliyet(i) = maliyet(i);
            % Parçacığın en iyi bilinen konumunu güncelle
            best_pozisyon(i, :) = pozisyon(i, :);
        end

        % Eğer mevcut parçacığın en iyi maliyeti, global en iyi maliyetten daha iyiyse,
        % global en iyi maliyet ve pozisyonu güncellenir.
        if best_maliyet(i) < gbest_maliyet    
            gbest_maliyet = best_maliyet(i);
            gbest_pozisyon = best_pozisyon(i, :);
        end
    end

    % Her iterasyonda elde edilen en iyi maliyet değeri bestmaliyet dizisine kaydedelim.
    bestmaliyet(it) = gbest_maliyet;
end

%% Grafikte Göster
figure;
plot(bestmaliyet);
xlabel('Iterasyon');
ylabel('En İyi Çözüm');
