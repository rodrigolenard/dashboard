# Dashboard do Pi-Star
Dashboard - Pi-Star

Para instalação acesse seu dashboard com:
http://pi-star.local/admin/expert/ssh

Ou entre em 'configuração' digitando seu usuario e senha, depois 'expert' e por último 'ssh access'.

Será solicitado mais uma vez o usuario e senha. Após digitar, abrirá o termina ssh do seu hotspot.

Após acessar a pagina digite os comando abaixo, linha por linha dando 'enter' ao final de cada comando.

rpi-rw

cd /var/www/dashboard

git clone https://github.com/rodrigolenard/dashboard-pistar.git

sudo chmod 777 /var/www/dashboard/dashboard

rpi-ro

Para acessar o novo dashboard acesse
http://pi-star.local/dashboard or http://ENDEREÇO DE IP/dashboard
