<?php
    require_once "header.php";
    require_once "role.php";
    require_once "privilegedUser.php";
    if($loggedin){
    $result1=queryMysql("CALL podaci_user($id)");
    while(mysqli_next_result($connection)){;}
        $row1 = $result1->fetch_assoc();
        $sender=sanitizeString($row1['username']);
    }
    if (isset($_GET['remove'])){

        $productId = sanitizeString($_GET['remove']);
            queryMysql("CALL brisi_artikal($productId)");
            while(mysqli_next_result($connection)){;} 
    }
    if (isset($_GET['addcart'])){

        $productId = sanitizeString($_GET['addcart']);
            
    }
    if (isset($_GET['show'])){

        $quantityError="";
        $ppriceError="";
        $productName = sanitizeString($_GET['show']);
        $result = queryMysql("CALL podaci_artikal('$productName') ");
        while(mysqli_next_result($connection)){;}
        $row = $result->fetch_assoc();
        $productId = $row['id'];
        $productStock=$row['stock'];
        $stock=$row['stock'];
        $price=$row['price'];
        if($ok){
            if($_SERVER['REQUEST_METHOD']=="POST"){
                $quantityError="";

                if(!empty($_POST['quantity'])){
                    $quantity=sanitizeString($_POST['quantity']);
                }
                else{
                    $quantityError="Unesite kolicinu";
                }
                if(!empty($_POST['price'])){
                    $pprice=sanitizeString($_POST['price']);
                }
                else{
                    $ppriceError="Unesite cenu";
                }
        
                if($quantityError==""){
                    queryMysql("CALL upis_nabavka($productId,NOW(),$quantity, $pprice)");
                    while(mysqli_next_result($connection)){;}
                }
        
            }
        }
        else{
            if($_SERVER['REQUEST_METHOD']=="POST"){
                $quantityError="";
                if(!empty($_POST['quantity'])){
                    $quantity=sanitizeString($_POST['quantity']);
                }
                else{
                    $quantityError="Unesite kolicinu";
                }
                $sumPrice=$price*$quantity;
                if($quantityError==""){
                    queryMysql("INSERT INTO cart(buyer_id, product_id, amount, sum_price)
                                VALUES($id,$productId,$quantity,$sumPrice)
                    ");
                }
        
            }
        }
            echo "<div class='show'>";
            echo "<img src='slike/p$productName.jpg'>";
            echo "<br>";
            echo "<div class='showT'>";
            echo "<p> Naziv artikla: " .$row['name']."</p>";
            echo "<p> Tip artikla: " .$row['type_id']."</p>";
            echo "<p> Cena :" .$row['price']." dinara"."</p>";
            echo "<p>Opis: ".$row['pdesc']."</p>";
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
                <input type="number" id="quantity" name="price" min="1" placeholder="cena po komadu">
                <span class="error"><?php echo $ppriceError ?></span>
                <input id="submit" type="submit" value="Dopuni">
                </form>
            </div>   
<?php
            echo "<a class='remove' href='indexsql.php?remove=$productId'>Izbriši artikl</a>";
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
               showProducts();
               
            ?>
            </p>
        </div>
    </div>
</body>
</html>