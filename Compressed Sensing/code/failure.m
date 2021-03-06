

[f, Fs] = wavread('failure');      % y is sound data, Fs is sample frequency.
t = (1:length(f))/Fs; 
n = length(f); 
m = ceil(n/5); 
k = randperm(n)';
k = sort(k(1:m));
b = f(k); %random samples

% Plot f and b.
% Plot idct(f) = inverse discrete cosine transform.

figure(1);
subplot(2,1,1)
plot(t,f,'b-',t(k),b,'k.')

title('f = signal, b = random sample')
subplot(2,1,2)
plot(idct(f))


title('c = idct(f)')
drawnow

% A = rows of DCT matrix with indices of random sample.

A = zeros(m,n);
for i = 1:m
   ek = zeros(1,n);
   ek(k(i)) = 1;
   A(i,:) = idct(ek);
end

% y = l_2 solution to A*y = b.

y = pinv(A)*b;

% x = l_1 solution to A*x = b.
% Use "L1 magic".

x = l1eq_pd(y,A,A',b,5e-3,32,1,1);%last two args are ignored if %A is a matrix,which it is in this case,hence any arguements may 
%be passed,A' is also ignored when A is a matrix

% Plot x and dct(x).
% Good comparison with f.

figure(2)
subplot(2,1,1)
plot(x)


title('x = {\it l}_1 solution, A*x = b ')
subplot(2,1,2)
plot(t,dct(x))

title('dct(x)')

% Plot y and dct(y).
% Lousy comparison with f.

figure(3)
subplot(2,1,1)
plot(y)


title('y = {\it l}_2 solution, A*y = b ')
subplot(2,1,2)
plot(t,dct(y))


title('dct(y)')

% Play three sounds.

sound(f,Fs)
pause(2)
sound(dct(x),Fs);
pause(2)
sound(dct(y),Fs)
