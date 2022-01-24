## randwall.sh
Ele cria um arquivo oculto no seu home contendo o nome do wallpaper dinâmico a ser usado no DWALL \${HOME}/.DWALL e qual foi o último usado \${HOME}/.DWALL.lw. <br />
Exemplo de uso: <br />
- `dwall -s $(cat ${HOME}/.DWALL)-s`

Execute o seu crontab de acordo com o [manual do DWALL](https://github.com/adi1090x/dynamic-wallpaper#setup-cron-job)


A ideia aqui &eacute; que o script execute e troque aleatoriamente os seus wallpapers dinamicos do [DWALL](https://github.com/adi1090x/dynamic-wallpaper) sem repetir o anterior.
<br /><br />

Para agendar a mudan&ccedil;a eu sugiro o anacron pois ele roda mesmo que seu desktop/notebook esteja desligado no dia que agendou, mas pode usar o crontab se voc&ecirc; tem a certeza que a m&aacute;quina estar&aacute; ligada. <br />
Dicas para usar o anacron: <br />
* https://www.tecmint.com/cron-vs-anacron-schedule-jobs-using-anacron-on-linux/
* https://askubuntu.com/questions/235089/how-can-i-run-anacron-in-user-mode
* man 8 anacron
* man 5 anacrontab


