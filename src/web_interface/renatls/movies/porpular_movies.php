
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Porpular Movies</title>

    <script>
        function sortTable(columnName) {
            // Get a reference to the table
            const table = document.querySelector("table");
            // Get the column index for the specified column name
            const columnIndex = Array.from(table.rows[0].cells).findIndex(cell => cell.textContent.trim() === columnName);
            // Sort the table data based on the chosen column
            const sortedData = Array.from(table.querySelectorAll("tbody tr"))
                .sort((row1, row2) => row1.cells[columnIndex].textContent.localeCompare(row2.cells[columnIndex].textContent));
            // Update the table with the sorted data
            table.querySelector("tbody").innerHTML = sortedData.map(row => row.outerHTML).join("");
        }
    </script>

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            flex-direction: column;
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
            margin-top: 5px;
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
            background-color: #ecf0f1;
            color: #2c3e50;
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
        }

        .button {
            color: white;
            text-decoration: none;
            font-weight: bold;
            padding: 10px 15px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        .tracking-button {
            background-color: #4caf50;
            margin-right: 10px;
        }

        .tracking-button:hover {
            background-color: #45a049; /* Change to a slightly darker green on hover */
        }

        .home-button {
            background-color: #3498db;
            margin-left: 10px;
        }

        .home-button:hover {
            background-color: #4caf50; /* Change to a slightly darker blue on hover */
        }

        .edit-button {
            background-color: #e74c3c;
            margin-left: 10px;
        }

        .edit-button:hover {
            background-color: #c0392b; /* Change to a slightly darker red on hover */
        }

        .unreturned-button {
            background-color: #e67e22;
            margin-left: 10px;
        }

        .unreturned-button:hover {
            background-color: #d35400; /* Change to a slightly darker orange on hover */
        }

        .returned-button {
            background-color: #3498db;
            margin-left: 10px;
        }

        .returned-button:hover {
            background-color: #2980b9; /* Change to a slightly darker blue on hover */
        }

        .sort-button {
            background-color: #9b59b6;
            margin-left: 10px;
        }

        .sort-button:hover {
            background-color: #8e44ad; /* Change to a slightly darker purple on hover */
        }
    </style>
</head>
<body>
    <h1>Porpular Movies</h1>

    <div class="table-container">
        <div class="table-body">
            <?php
            include '../../db_connection.php';

            $sql = "SELECT
                        m.title AS `top_3_popular_movies`,
                        COUNT(mr.movie_id) AS `popularity_rate`,
                        m.movie_id,
                        m.genre
                    FROM `movies` m
                    JOIN `movie_rentals` mr
                    ON m.movie_id = mr.movie_id
                    WHERE (SELECT COUNT(mr.movie_id) FROM `movie_rentals`) >= 1
                    GROUP BY mr.movie_id
                    ORDER BY `popularity_rate` DESC
                    LIMIT 3";
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
                echo "No records found";
            }

            // Close the database connection
            $conn->close();
            ?>
        </div>
    </div>

    <div class="buttons-container">
        <!-- <button class="button sort-button" onclick="showSortOptions()">Sort By</button> -->
        <div id="sort-options" class="sort-options">
            </div>
    </div>

    <div class="buttons-container">
        <a href="movies.php" class="button porpular_movies-button">Movies</a>
        <a href="total_rentals.php" class="button total_rentals-button">Total Rentals</a>
        <a href="../view-rentals.php" class="button movie_rentals-button">Rentals</a>
        <a href="../subscribers/subscribers.php" class="button subscribers-button">Subscribers</a>
        <a href="../../index.html" class="button home-button">Home</a>

    </div>
</body>
</html>



