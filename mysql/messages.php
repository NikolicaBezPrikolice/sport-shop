<?php
require_once 'header.php';
if(!$loggedin){
    die("</div></body></html>");
}

$viewId=$id;

if(isset($_GET['delete'])){
    $messageId=sanitizeString($_GET['delete']);
    queryMysql("CALL izbrisi_poruku($messageId)");
}

$result=queryMysql("CALL prim_poruke($viewId)");

while(mysqli_next_result($connection)){;}

while($row=$result->Fetch_assoc()){
    echo "<div class='message'>";
    echo date("j.n.Y. H:i:s: ",$row['time']);
    $authId=$row['auth_id'];
    $messageId=$row['id'];
    $result1=queryMysql("SELECT username FROM users WHERE id=$authId");
    $row1=$result1->fetch_assoc();
    echo $row1['username'];
    echo "<br><br>&quot;". $row['message'] ."&quot;";
    echo "<br><br><a href='messages.php?delete=$messageId'>Izbrisi poruku</a>";
    echo "</div>";
}