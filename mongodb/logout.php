<?php
    require_once 'header.php';
    if(isset($_SESSION['username'])){
        $ok=false;
        $_SESSION=array();
        session_destroy();
        header("Location: login.php");
    }
    else{
        echo "<div class='content'>Niste prijavljeni!</div>";
    }
?>

</div>
</body>
</html>