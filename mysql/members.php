<?php

require_once 'header.php';
    if(!$loggedin){
        die("<h3>You must <a href='login.php'>login<a> to see this page</h3></div></body></html>");
    }

    if(isset($_GET['id'])){
        $userId=sanitizeString($_GET['id']);
        $result1=queryMysql("CALL podaci_profil($userId)");
        while(mysqli_next_result($connection)){;}
        if($result1->num_rows){
            $row=$result1->fetch_assoc();
            $view=$row['name'];
        }
        else{
            $result2=queryMysql("CALL podaci_user($userId)");
            while(mysqli_next_result($connection)){;}
            $row=$result2->fetch_assoc();
            $view=$row['username'];
        }
        echo "<h3>$view Profil:</h3>";
        showProfile($userId);
        die("</br><a href='members.php'>Vrati se na prethodnu stranicu</a></div></body></html>");
    }

?>

<div class="content">
        <h3>Klijenti na platformi:</h3>

        <?php
            $result=queryMysql("CALL korisnici($id)");
            echo "<ul class='members'>";
            while($row=$result->fetch_assoc()){
                echo "<li>";
                $userId=$row['uid'];
                echo "<a href='members.php?id=$userId'>";
                echo $row['name'];
                echo " (";
                echo $row['username'];
                echo ")";
                echo "</a>";
                echo "</li>";
            }
        ?>
    </div>

</div>
</body>
</html>