<?php
    require 'vendor/autoload.php';

    $connection=new MongoDB\Client('mongodb://localhost:27017');

    $db=$connection->shopdb;

    
?>