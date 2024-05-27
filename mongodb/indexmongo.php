<?php
require "header.php";

if (isset($_GET['remove'])){

    $productId = $_GET['remove'];
    $delete=$db->products->deleteOne(array('_id'=>new MongoDB\BSON\ObjectId("$productId")));
}

if (isset($_GET['show'])){

    $quantityError="";
    $ppriceError="";
    $productName = $_GET['show'];
    $result=$db->products->findOne(array('pname'=>$productName));
    $productId = $result->_id;
    $stock=$result->pstock;
    $price=$result->pprice;
    if($ok){
        if($_SERVER['REQUEST_METHOD']=="POST"){
            $quantityError="";

            if(!empty($_POST['quantity'])){
                $quantity=$_POST['quantity'];
            }
            else{
                $quantityError="Unesite kolicinu";
            }
            if($quantityError==""){
                $update=$db->products->updateOne(['_id'=>$productId],
                    ['$set'=>['pstock'=>$stock+$quantity]]);
            }
    
        }
    }
    else{
        if($_SERVER['REQUEST_METHOD']=="POST"){
            $quantityError="";
            if(!empty($_POST['quantity'])){
                $quantity=$_POST['quantity'];
            }
            else{
                $quantityError="Unesite kolicinu";
            }
            $sumPrice=$price*$quantity;
            if($quantityError==""){
                $update=$db->cart->insertOne(array('buyer'=>$user, 'product'=>$productName, 'amount'=>$quantity, 'cost'=>$sumPrice));
            }
    
        }
    }
        echo "<div class='show'>";
        echo "<img src='slike/$productName.jpg'>";
        echo "<br>";
        echo "<div class='showT'>";
        echo "<p> Naziv artikla: " .$result->pname."</p>";
        echo "<p> Tip artikla: " .$result->ptype."</p>";
        echo "<p> Cena :" .$result->pprice." dinara"."</p>";
        echo "<p>Opis: ".$result->pdesc."</p>";
        if($ok){
            echo "<span class='name'>"."Na stanju: " .$stock."</span>";
        }
        echo "<br>";

        if(!$ok && $loggedin){
        echo "</div>";
        ?> 
        <div class="content">
            <form action="" method="POST">
            <label for="quantity" id="dopuni">Dodaj u korpu:</label><br>
            <input type="number" id="quantity" name="quantity" min="1">
            <span class="error"><?php echo $quantityError ?></span>
            <input id="submit" type="submit" value="Dopuni">
            </form>
        </div>   

<?php       }
        if($ok){
        echo "<br>";
        
        ?> 
        <div class="content">
            <form action="" method="POST">
            <label for="quantity" id="dopuni">Dopuni:</label><br>
            <input type="number" id="quantity" name="quantity" min="1" placeholder="kolicina">
            <span class="error"><?php echo $quantityError ?></span>
            <input id="submit" type="submit" value="Dopuni">
            </form>
        </div>   
<?php
        echo "<a class='remove' href='indexmongo.php?remove=$productId'>Izbriši artikl</a>";
        }
        echo "</div>";
    die("</div></body></html>");
       
}

?>

<script>
function Function() {
  alert("Artikal je uspesno dopunjen!");
}
</script>
<div class="content">
            <?php   
                $result=$db->products->find();
                if($result){
                    foreach($result as $row){
                        $productName=$row->pname;
                        $productId=$row->_id;
                        echo "<div class='veh'>";
                        echo "<a href='indexmongo.php?show=$productName'>";
                        if(file_exists("slike/$productName.jpg")){
                            echo"<img src='slike/$productName.jpg' class='pf'>";
                        }
                        echo "</a>";
                        echo "<div class='vehw'>";
                        echo "<span class='name'>" .$row->pname."</span>";
                        echo "<br>";
                        if($row->pstock>0){
                            echo "<span class='price'>" .$row->pprice." rsd"."</span>";
                        }
                        else{
                            echo "<span class='price'>" ."Nema na stanju"."</span>";
                        }
                        echo "<br>";
                        if($ok){
                        echo "<span class='name'>"."Na stanju: " .$row->pstock."</span>";
                        echo "<br>";
                        echo "<br>";
                        echo "<a class='remove' href='indexmongo.php?show=$productName#dopuni'>Dopuni stanje</a>";
                        echo "<br>";
                        echo "<a class='remove' href='indexmongo.php?remove=$productId'>Izbriši artikal</a>";
                        }
                        echo "</div>";
                        echo "</div>";
                    }
                }
                else{
                    echo "<p> You still don't have products. Add one.</p>";
                }
            
               
            ?>
            </p>
        </div>
    </div>
</body>
</html>