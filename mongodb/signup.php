<?php
require('header.php');
$error="";
if(isset($_SESSION['user'])){
    header('Location: indexmongo.php');
}

if(isset($_POST['username']) && isset($_POST['password'])){
    $username=$_POST['username'];
    $password=$_POST['password'];
        if($username == "" || $password== ""){
            $error="Popunite sva polja.";
        }
    else{
        $result=$db->users->findOne(array('username'=>$username));
        if($result){
            $error="Korisničko ime je zauzeto.";
        }
        else{
            $codedPassword=hash('sha256',$password);
            $result=$db->users->insertOne(array('username'=>$username, 'password'=>$codedPassword));
            header("Location: login.php");
        }
    }
}

?>
<html>
<body>
<div class="content">
        <h2>Napravite nalog</h2>
        <div class="error">
            <?php echo $error; ?> 
        </div>
        <form action="signup.php" method="post">
            <label for="username">Korisničko ime:</label><br>
            <input type="text" name="username" id="username" placeholder="Vaše korisničko ime...">
            <br>
            <label for="password">Lozinka:</label><br>
            <input type="password" name="password" id="password" placeholder="Vaša lozinka...">
            <br>
            <input id="submit" type="submit" value="Registruj se!">
        </form>
    </div>
</div>