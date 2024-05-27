<?php
    require_once 'header.php';
    $error='';

    if($_SERVER["REQUEST_METHOD"]=="POST"){
        $username=$connection->real_escape_string($_POST['username']);
        $password=$connection->real_escape_string($_POST['password']);

        if($username=="" || $pasword=""){
            $error="Korisničko ime i/ili lozinka ne mogu ostati prazni";
        }
        else{
            $result=queryMysql("CALL provera_username('$username')");
            if($connection->error){
                $error="Error in query: $connection->error";
            }
            else{
                if($result->num_rows==0){
                    $error="Korisničko ime ne postoji";
                }
                else{
                    $row=$result->fetch_assoc();
                    
                    if(!password_verify($password, $row['password'])){
                        $error="Netačna lozinka";
                    }
                    else{
                        $_SESSION['id']=$row['id'];
                        $_SESSION['username']=$row['username'];
                        header('Location: indexsql.php');
                    }
                }
            }
        }
    }
?>

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