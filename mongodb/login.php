<?php

require_once('header.php');
if(isset($_SESSION['user'])){
    header('Location: indexmongo.php');
}
$error="";
if(isset($_POST['username']) && isset($_POST['password'])){
    $username=$_POST['username'];
    $password=hash('sha256', $_POST['password']);
    if($username=="" || $pasword=""){
        $error="Korisničko ime i/ili lozinka ne mogu ostati prazni";
    }
    else{
        $result=$db->users->findOne(array('username'=>$username, 'password'=>$password));
        if(!$result){
            $error="Korisničko ime ili sifra su pogresni";
        }else{
            $_SESSION['id']=$result->_id;
            $_SESSION['username']=$result->username;
            header('Location: indexmongo.php');
        }
    }
}

?>
<html>
    <body>
<div class="content">
        <h2>Ulogujte se sa postojecim nalogom</h2>
        <div class="error">
            <?php echo $error; ?>
        </div>
        <form action="login.php" method="post">
            <label for="username">Korisničko ime:</label><br>
            <input type="text" name="username" id="username" placeholder="Vaše korisničko ime...">
            <br>
            <label for="password">Lozinka:</label><br>
            <input type="password" name="password" id="password" placeholder="Vaša lozinka...">
            <br>
            <input id="submit" type="submit" value="Ulogujte se!">
        </form>
    </div>
</div>
</body>
</html>