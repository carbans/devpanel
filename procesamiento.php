<?php
if ($_POST['enviar']=='enviar') {
  $usuario=$_POST['usuario'];
  $contraseña=$_POST['contraseña'];
  $usuariobd=$_POST['usuariobd'];
  $contraseñabd=$_POST['contraseñabd'];
  $subdominio=$_POST['subdominio'];

  //Comenzamos ejecutando un script en bash y pasandole como parametros las variables recuperadas
  //de POST
  $command='./devpanel.sh'.$usuario.' '.$contraseña;
    system($command);
//Buscar el registro que diga que se ha ejecutado correctamente
    if () {
      echo 'Se ha ejecutado correctamente tu acción';
      echo '<br/>';
      echo "Recibiras un correo con toda la información del proceso";
    }
}
 ?>
