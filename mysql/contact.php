<?php
require_once 'header.php';

if($_SERVER["REQUEST_METHOD"]=="POST"){
    $message=sanitizeString($_POST['message']);
    if($message !="" && $loggedin){
        $adminId=1;
        $time=time();
        queryMysql("CALL posalji_poruku($id, $adminId, $time, '$message')");
        echo"<h4>Poruka poslata</h4>";
    }
}
?>

<form action="" method="POST" <?php if(!$loggedin){?>onsubmit="myFunction()" <?php }?>>
    <h3>Kontaktirajte nas:</h3>
    <textarea name="message" id="message" cols="40" rows="5"></textarea>
    <br>
    <input id="submit" type="submit" Value="Posalji">

</form>
<script>
function myFunction() {
  alert("Morate biti ulogovani da biste poslali poruku");
}
</script>
<hr>
<div class="info">
<p> <img src="slikesajt/location.png" class="icons"> Ulica Niška 20, Niš
</p>
<p><img src="slikesajt/phone.png" class="icons"> 060876543
</p>
<p><img src="slikesajt/email.png" class="icons"> rentacar@email.com
</p>
</div>

</div>
</body>
</html>