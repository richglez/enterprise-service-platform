<?php

$host = 'postgres';
$port = '5432';
$dbname = 'enterprise_platform';
$user = 'rich';
$password = 'richpassword';

try {

    $pdo = new PDO(
        "psgql:host=$host;port=$port;dbname=$dbname",
        $user,
        $password,
    );

    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {

    die($e->getMessage());
}
