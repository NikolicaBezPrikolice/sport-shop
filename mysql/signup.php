<?php
    require_once "header.php";

    $error="";
    if($_SERVER["REQUEST_METHOD"]=="POST"){
        $username=$connection->real_escape_string($_POST['username']);
        $password=$connection->real_escape_string($_POST['password']);
        if($username == "" || $password== ""){
            $error="Popunite sva polja.";
        }
        else{
            $result=queryMysql("CALL provera_username('$username')");
            while(mysqli_next_result($connection)){;}
           // $result=queryMysql("SELECT * FROM users WHERE username='$username'");
            if($result->num_rows >0){
                $error="Korisničko ime je zauzeto.";
            }
            else{
                $codedPassword=PASSWORD_HASH($password, PASSWORD_DEFAULT);
                queryMysql("CALL upis_korisnika('$username','$codedPassword')");
                while(mysqli_next_result($connection)){;}
                header("Location: login.php");
            }
        }
    }
?>

<div class="content">
        <h2>Napravite nalog</h2>
          <div class="error">
            <?php echo $error; ?> 
        </div>
        <form action="signup.php" method="post">
            <label for="username">Korisničko ime:</label><br>
            <input type="text" name="username" id="username" placeholder="Vaše korisničko ime..." onBlur="checkUser(this)">
            <br>
            <label for="password">Lozinka:</label><br>
            <input type="password" name="password" id="password" placeholder="Vaša lozinka...">
            <br>
            <input id="submit" type="submit" value="Registruj se!">
        </form>
    </div>
</div>