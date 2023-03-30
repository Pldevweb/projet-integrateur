<?php

// Database configuration
$dbHost = 'localhost';      // Database host
$dbUsername = 'root';       // Database username
$dbPassword = '';   // Database password
$dbName = 'dbproject';    // Database name

// Create a database connection
$conn = new mysqli($dbHost, $dbUsername, $dbPassword, $dbName);

// Check for connection errors
if ($conn->connect_error) {
    die('Database connection failed: ' . $conn->connect_error);
}

// Set the character set to UTF-8
$conn->set_charset('utf8mb4');
