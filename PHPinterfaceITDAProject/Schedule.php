<?php session_start(); 
  $pdo = new PDO('mysql:host=localhost;port=3306;dbname=itdaproject','CHW', 'community');
	$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

if (!isset($_SESSION['staffUsername'])){ //Redirects non-logged in users back to the Login Page
	header('Location: Login.php');
	return;
}
?>
<!DOCTYPE html>
<html>
    <head>
    	<link type="text/css" rel="stylesheet" href="Schedule.css">
        <title>Schedule</title>
        <header> 
				<nav>
					<ul>
						<li id="homenav">
							<a href = "Home.php">HOME</a>
						</li>
						<li>
							<a href = "Household.php">Patient's Household Members</a>
						</li>
						<li>
							<a href = "Inbox.php">Inbox</a>
						</li>
						<li>
							<a href = "video.php">Videos</a>
						</li>
						<li>
							<a href = "Patient.php">Patients</a>
						</li>
						<li style="background-color: #9c0202;">
							<a href = "Schedule.php">Schedule</a>
						</li>
            <li>
              <a href = "BloodSugarTest.php">Blood Sugar Test</a>
            </li>
						<li>
							<a href = "Drug.php">Drug Administration</a>
						</li>
						<li>
							<a href = "LogOutCHW.php">Logout</a>
						</li>
					</ul>
				</nav>

			</header>

    </head>
    <body>
    	<br><br><br><br><br>
<?php 
$todayDate = date("Y-m-d");
$yesterday = date("Y-m-d", strtotime("yesterday"));
$tomorrow = date("Y-m-d", strtotime("tomorrow"));
$rowFormat;
$statement = $pdo->prepare("SELECT * FROM chwstaffviewappointment where StaffIdentifier = :staffID ORDER BY AppointmentDate DESC;");
  		$statement->execute(array( 
	       ':staffID' => $_SESSION['StaffID'],
	    ));
echo '<center><table border="1" style = "text-align:center">'; 
echo ("<tr><th>Yesterday,<br>Today,<br>Tomorrow</th><th>AppointmentDate</th><th>AppointmentTime</th><th>PatientName</th><th>PatientSurname</th><th>Address</th><th>PhoneNumber</th><th>EmailAddress</th><th>	Gender</th><th>Age</th></tr>"); 
while ( $row = $statement->fetch(PDO::FETCH_ASSOC)) { 
          echo ("<tr><td>");
          	if($row['AppointmentDate'] > $tomorrow){	
          	}else{
          		if($row['AppointmentDate'] < $tomorrow){
          		}else{
          			echo('<span style="background-color:#ffb3ff; font-weight: bold;">Tomorrow</span>');
          		}
          	}
          	if($row['AppointmentDate'] > $yesterday){	
          	}else{
          		if($row['AppointmentDate'] < $yesterday){
          		}else{
          			echo('<span style="background-color:#ffb84d; font-weight: bold;">Yesterday</span>');
          		}
          	}
          	if($row['AppointmentDate'] > $todayDate){
          	}else{
          		if($row['AppointmentDate'] < $todayDate){
          		}else{
          			echo('<span style="background-color: #66ffff; font-weight: bold;">Today</span>');
          		}
          	}          
          echo("</td><td>");
          echo($row['AppointmentDate']);
          echo("</td><td>");
          echo($row['AppointmentTime']);
          echo("</td><td>");
          echo($row['PatientName']);
          echo("</td><td>");
          echo($row['PatientSurname']);
          echo("</td><td>");
          echo($row['Address']);
          echo("</td><td>");
          echo($row['PhoneNumber']);
          echo("</td><td>");
          echo($row['EmailAddress']);
          echo("</td><td>");
          echo($row['Gender']);
          echo("</td><td>");
          echo($row['Age']);
          echo("</td></tr>\n");
      }
      echo "</table></center>\n"; 
?>
    </body>
    <footer>
    	
    </footer>
</html>



