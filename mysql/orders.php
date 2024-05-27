<?php
require_once "header.php";
if (!$loggedin){
    header("Location: login.php");
}
?>

<div class="content">       
    <?php
        $kbooks = false;
        $result = queryMysql("CALL podaci_orders($id)");
        echo "<h3>Istorija narudzbina:</h3>";
        echo "<table style='width:100%' border='1px solid black'>";
            while($row = $result->fetch_assoc()){
                echo "<tr>";
                echo "<td>";
                echo "Naziv: ".$row['name'];
                echo "</td>";
                echo "<td>";
                echo "Kolicina: ".$row['amount'];
                echo "</td>";
                echo "<td>";
                echo "Placeno: ".$row['sum_price'];
                echo "</td>";
                echo "<td>";
                echo "Datum: ".date("j.n.Y. H:i:s: ",$row['vreme']);
                echo "</td>";
                echo "</tr>" ;
                $kbooks = true;
            }
            echo "</table>";
        if($kbooks == FALSE){
            echo "<div><h2>Nemate narudzbina</h2></div>";
            echo "<div class='dknjige'><a href='indexsql.php'>Naruci</div>";        
        }
    ?>
  </div>