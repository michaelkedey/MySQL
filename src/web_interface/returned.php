<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Returned Devices</title>

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }

        h1 {
            text-align: center;
            color: #3498db;
            margin-top: 10px;
            margin-bottom: 10px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .table-container {
            width: 90%;
            max-width: 1200px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            overflow: auto;
            margin-top: 20px;
            flex-grow: 1;
        }

        .table-body {
            overflow-y: auto;
            max-height: calc(100vh - 150px);
            overflow-x: scroll;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            box-sizing: border-box;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
            white-space: nowrap;
        }

        th {
            background-color: #3498db;
            color: white;
            position: sticky;
            top: 0;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        .buttons-container {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
            margin-bottom: 20px;
        }

        .button {
            color: white;
            text-decoration: none;
            font-weight: bold;
            padding: 10px 15px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        .home-button {
            background-color: #3498db;
            margin-right: 10px;
        }

        .home-button:hover {
            background-color: #4caf50;
        }

        .register-button {
            background-color: #e74c3c;
        }

        .register-button:hover {
            background-color: #c0392b;
        }
    </style>
</head>
<body>
    <h1>Returned Devices</h1>

    <div class="table-container">
        <div class="table-body">
            <?php
            // Include your database connection code here
            // For example, if your database connection code is in a separate file (e.g., db_connection.php):
            // include('db_connection.php');

            // Replace the following with your actual database connection details
            $servername = "localhost";
            $username = "root";
            $password = "";
            $dbname = "iridis assets tracker";

            // Create connection
            $conn = new mysqli($servername, $username, $password, $dbname);

            // Check connection
            if ($conn->connect_error) {
                die("Connection failed: " . $conn->connect_error);
            }

            // Retrieve data from the tracking_register table where Returned Date is not '0000-00-00'
            $sql = "SELECT
                Id,
                Name, 
                Device_type, 
                Iridis_number, 
                Acquisition_date, 
                Return_date
            FROM tracking_register WHERE `Return_date` != '0000-00-00'";
            $result = $conn->query($sql);

            if ($result->num_rows > 0) {
                // Display the data in a table
                echo "<table>";
                echo "<tr>";
                // Display column headers
                while ($fieldinfo = $result->fetch_field()) {
                    echo "<th>{$fieldinfo->name}</th>";
                }
                echo "</tr>";

                // Display table data
                while ($row = $result->fetch_assoc()) {
                    echo "<tr>";
                    foreach ($row as $value) {
                        echo "<td>{$value}</td>";
                    }
                    echo "</tr>";
                }
                echo "</table>";
            } else {
                echo "No returned devices found";
            }

            // Close the database connection
            $conn->close();
            ?>
        </div>
    </div>

    <div class="buttons-container">
        <a href="index.html" class="button home-button">Home</a>
        <a href="view_tracking.php" class="button register-button">Tracking Register</a>
    </div>
</body>
</html>
