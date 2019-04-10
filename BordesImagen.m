clear all;
close all;
clc;

X = imread('Prueba.jpg');
Y = rgb2gray(X);

[sizeX,sizeY] = size(Y);

%Gradiente
%Matriz Vertical
for i=1:sizeX
    for j=1:sizeY-1
        V(i,j) = Y(i,j) - Y(i,j+1);
    end
end

%Matriz Horizontal
for i=1:sizeX-1
    for j=1:sizeY
        H(i,j) = Y(i+1,j) - Y(i,j);
    end
end

%Ajuste de matriz
for i=1:sizeX
    V(i,sizeY) = 0;
end
for j=1:sizeY
    H(sizeX,j) = 0;
end

%Matriz Gradiente
for i=1:sizeX
    for j=1:sizeY
        x = V(i,j)^2;
        y = H(i,j)^2;
        G(i,j) = sqrt(double(x + y));
    end
end

%Matriz Final
for i=1:sizeX
    for j=1:sizeY
        if G(i,j) > 5
            F(i,j) = 255;
        else
            F(i,j) = 0;
        end
    end
end

%Derivadas
%Matriz Promedio
for i=1:sizeX
    for j=1:sizeY
        if j == 1
            P(i,j) = (Y(i,j))/2 + (Y(i,j+1))/2;
        else
            if j == sizeY
                P(i,j) = (Y(i,j-1))/2 + (Y(i,j))/2;
            else
                P(i,j) = (Y(i,j-1))/3 + (Y(i,j))/3 + (Y(i,j+1))/3;
            end
        end
    end
end

%Matriz Derivada
for i=1:sizeX
    for j=1:sizeY
        if j == 1
            D(i,j) = (P(i,j))/2 + (P(i,j+1))/2;
        else
            if j == sizeY
                D(i,j) = (P(i,j-1))/2 + (P(i,j))/2;
            else
                D(i,j) = (P(i,j+1))/2 - (P(i,j-1))/2;
            end
        end
    end
end

%Matriz Segunda Derivada
for i=1:sizeX
    for j=1:sizeY
        if j == 1
            S(i,j) = (D(i,j))/2 + (D(i,j+1))/2;
        else
            if j == sizeY
                S(i,j) = (D(i,j-1))/2 + (D(i,j))/2;
            else
                S(i,j) = (D(i,j+1))/2 - (D(i,j-1))/2;
            end
        end
    end
end

%Sobel
%Máscara Mx y My Sobel
Mx = [-1 0 1; -2 0 2; -1 0 1];
My = [-1 -2 -1; 0 0 0; 1 2 1];

%Máscara Mx y My Roberts
%Mx = [-1 0 0; 0 1 0; 0 0 0];
%My = [0 0 -1; 0 1 0; 0 0 0];

%Convolución de Matrices
convX = conv2(Mx,Y);
convY = conv2(My,Y);

So = Y;

%Magnitud
for i=1:sizeX
    for j=1:sizeY
        So(i,j) = sqrt((convX(i,j)^2)+(convY(i,j)^2));
        if So(i,j)<50
            So(i,j)= 0;
        else
            So(i,j)=255;
        end
    end
end

figure,imshow(X); 
title('Original')
figure,imshow(F); 
title('Gradientes')
figure,imshow(S); 
title('Derivada')
figure,imshow(So); 
title('Sobel')