<?php
require_once "header.php";
if (!$loggedin){
    header("Location: login.php");
}
?>

<div class="content">       
    <?php
        $kbooks = false;
        $result = queryMysql("SELECT products.name, weekly.sold FROM weekly INNER JOIN products ON products.id=weekly.product_id");
        echo "<h3>Protekla nedelja:</h3>";
        echo "<table style='width:100%' border='1px solid black'>";
            while($row = $result->fetch_assoc()){
                echo "<tr>";
                echo "<td>";
                echo "Naziv: ".$row['name'];
                echo "</td>";
                echo "<td>";
                echo "Prodato: ".$row['sold'];
                echo "</td>";
                echo "</tr>" ;
                $kbooks = true;
            }
            echo "</table>";
        if($kbooks == FALSE){
            echo "<div><h2>Nema prodaje ove nedelje</h2></div>";      
        }
    ?>
  </div>