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
    // throw exceptions if something goes wrong
} catch (PDOException $e) {

    // Stop the script completely and display the error message before dying
    // die($e->getMessage());

    throw new RuntimeException("Failed to connect to the database: " . $e->getMessage());
    // more profesionally throwing an exception insted of dying
}
