<?php

require_once 'header.php';
    if(!$loggedin){
        die("<h3>You must <a href='login.php'>login<a> to see this page</h3></div></body></html>");
    }

    if(isset($_GET['id'])){
        $userId=$_GET['id'];
        $result1=$db->users->findOne(array('_id'=>new MongoDB\BSON\ObjectId("$userId")));
        if($result1->count()>3){
            $view=$result1->name;
        }
        else{
            $view=$result1->username;
        }
        echo "<h3>$view Profil:</h3>";
        if($result1->count()>3)
        {
            echo"<div class='profile'>";
            echo $result1->name;
            echo"<br>";
            echo $result1->email;
            echo "<br>";
            echo $result1->phone;
            echo "<br>";
            echo $result1->address;
            echo "<br>";
            echo $result1->place;
            echo "</div>";
        }
        die("</br><a href='members.php'>Vrati se na prethodnu stranicu</a></div></body></html>");
    }
?>

<div class="content">
        <h3>Klijenti na platformi:</h3>

        <?php
            $result=$db->users->find(array('username'=>array('$nin'=>array($user))));
            $itr = new IteratorIterator($result);
            $itr -> rewind();
            echo "<ul class='members'>";
            while($result = $itr->current()){
                echo "<li>";
                $userId=$result['_id'];
                echo "<a href='members.php?id=$userId'>";
                echo " (";
                echo $result['username'];
                echo ")";
                echo "</a>";
                echo "</li>";
                $itr->next();
            }
        ?>
    </div>

</div>
</body>
</html>