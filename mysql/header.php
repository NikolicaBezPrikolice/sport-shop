<?php 
    session_start();
    $loggedin=false;
    $user="Guest";
    if(isset($_SESSION['username'])){
        $loggedin=true;
        $id=$_SESSION['id'];
        $user=$_SESSION['username'];
    }

    require_once "functions.php";

    require_once "privilegedUser.php";

$ok=false;
if(isset($_SESSION['username'])){
    $user=PrivilegedUser::getByUsername($_SESSION['username']);
    if($user !== false && $user->hasPrivilege("Run SQL")){
        $ok=true;
    }
}
?>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <img src="slikesajt/banner.jpg" alt="Rent a car" id="header_image">
        <ul class="menu">
        <?php if($ok){ ?>
                <li>
                <a href="indexsql.php">Početna</a>
            </li>
            <li>
            <a href="members.php">Korisnici</a>
            </li>
            <li>
            <a href="addProduct.php">Dodaj</a>
            </li>
            <li>
            <a href="weekly.php">Sedmica</a>
            </li>
            <li>
            <a href="messages.php">Poruke</a>
            </li>
            <li>
                <a href="logout.php">Odjavi se</a>
            </li>
            <?php }
             else if($loggedin){ ?>
            <li>
            <a href="indexsql.php">Početna</a>
            </li>
            <li>
            <a href="cart.php">Korpa</a>
            </li>
            <li>
            <a href="orders.php">Narudzbine</a>
            </li>
            <li>
            <a href="messages.php">Poruke</a>
            </li>
            <li>
            <a href="contact.php">Kontakt</a>
            </li>
            <li>
            <a href="profile.php">Profil</a>
            </li>
            <li>
                <a href="logout.php">Odjavi se</a>
            </li>
            <?php } 
            else {?>
                <li>
                <a href="indexsql.php">Početna</a>
            </li>
            <li>
            <a href="contact.php">Kontakt</a>
            </li>
            <li>
                <a href="signup.php">Registruj se</a>
            </li>
            <li>
                <a href="login.php">Prijavi se</a>
            </li>
            <?php } ?>
        </ul>