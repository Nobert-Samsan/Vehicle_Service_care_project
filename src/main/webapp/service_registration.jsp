<%@ page import="com.services.authentication.AuthenticationUtil" %>
<%
if (!AuthenticationUtil.isAuthenticated(request)) {
    // If the user is not authenticated, redirect to the login page
    response.sendRedirect("index.jsp"); // Replace "login.jsp" with your login page URL
}
%>
<%@include file="structure.jsp"%>
<%@page import="java.sql.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.services.database.DatabaseConnection"%>

<%
String username = (String) request.getSession().getAttribute("username");

if (request.getParameter("submit") != null) {
    // Get form data
    String dateString = request.getParameter("date");
    String timeString = request.getParameter("preferred-time");
    String location = request.getParameter("preferred-location");
    String mileageStr = request.getParameter("current-mileage");
    String vehicleNo = request.getParameter("vehicle-registration");
    String message = request.getParameter("message");

    try {
        // Convert String date to java.sql.Date
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date parsedDate = dateFormat.parse(dateString);
        java.sql.Date sqlDate = new java.sql.Date(parsedDate.getTime());

        // Convert String mileage to Integer
        int mileage = Integer.parseInt(mileageStr);

        // Convert String time to java.sql.Time
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
        java.util.Date parsedTime = timeFormat.parse(timeString);
        java.sql.Time sqlTime = new java.sql.Time(parsedTime.getTime());

        // Perform database insertion
        
        	DatabaseConnection dbConnection = new DatabaseConnection();
             Connection connection = dbConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement("INSERT INTO vehicle_service (date, time, location, vehicle_no, mileage, message, username) VALUES (?, ?, ?, ?, ?, ?, ?)");
             

            // Set parameters for the prepared statement
            preparedStatement.setDate(1, sqlDate);
            preparedStatement.setTime(2, sqlTime);
            preparedStatement.setString(3, location);
            preparedStatement.setString(4, vehicleNo);
            preparedStatement.setInt(5, mileage);
            preparedStatement.setString(6, message);
            preparedStatement.setString(7, username);

            // Execute the SQL query
            int rowsAffected = preparedStatement.executeUpdate();

            if (rowsAffected > 0) {
                // Redirect to a success page or perform any other necessary action
                response.sendRedirect("service_registration.jsp?msg=success");
            } else {
                // Redirect to an error page
                response.sendRedirect("service_registration.jsp?msg=failure");
            }
        
    } catch (Exception e) {
        e.printStackTrace();
        // Redirect to an error page
        response.sendRedirect("service_registration.jsp?msg=exception");
    }
}
%>

<!doctype>
<html>
<head>

<style>
   
    #service {
        text-align: center;
        padding: 50px;
         font-family: Arial;
    }

    h2 {
        color: #333;
    }

    #reservation-form {
        max-width: 600px;
        margin: 0 auto;
        margin-bottom:20px;
        background-color: #fff;
        padding: 20px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        border-radius: 5px;
    }

    label {
        display: block;
        margin-top: 10px;
        font-weight: bold;
    }

    input,
    select,
    textarea {
        width: 100%;
        padding: 10px;
        margin-top: 5px;
        margin-bottom: 15px;
        box-sizing: border-box;
    }

    button {
        background-color: #d9534f;
        color: white;
        padding: 15px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
    }

    button:hover {
        background-color: #c9302c;
    }

    #date-error {
        color: red;
    }
</style>

    
</head>
<body>
        		<section id="service">


	         
    <form id="reservation-form" method="post" action="">
    
     <input type="hidden" id="username" name="username" value="<%= username %>">
       
        <label for="date">Date</label>
<input type="date" name="date" id="date" placeholder="Enter date" class="form-control" required>
<span id="date-error" style="color: red;"></span>

        <label for="preferred-time">Preferred Time:</label>
        <select id="preferred-time" name="preferred-time">
            <option value="10:00:00">10 AM</option>
            <option value="11:00:00">11 AM</option>
            <option value="12:00:00">12 PM</option>
        </select>

        <label for="preferred-location">Preferred Location:</label>
        <select id="preferred-location" name="preferred-location">
            					<option value="Colombo">Colombo</option>
								<option value="Gampaga">Gampaga</option>
								<option value="Kaluthara">Kaluthara</option>
								<option value="Galle">Galle</option>
								<option value="Matara">Matara</option>
								<option value="Hambanthota">Hambanthota</option>
								<option value="Kandy">Kandy</option>
								<option value="Matale">Matale</option>
								<option value="Nuwara Eliya">Nuwara Eliya</option>
								<option value="Kegalle">Kegalle</option>
								<option value="Ratnapura">Ratnapura</option>
								<option value="Anuradhapura">Anuradhapura</option>
								<option value="Polonnaruwa">Polonnaruwa</option>
								<option value="Puttalam">Puttalam</option>
								<option value="Kurunegala">Kurunegala</option>
								<option value="Badulla">Badulla</option>
								<option value="Monaragala">Monaragala</option>
								<option value="Trincomalee">Trincomalee</option>
								<option value="Batticaloa">Batticaloa</option>
								<option value="Ampara">Ampara</option>
								<option value="Jaffna">Jaffna</option>
								<option value="Kilinochchi">Kilinochchi</option>
								<option value="Mannar">Mannar</option>
								<option value="Mullaitivu">Mullaitivu</option>
								<option value="Vavuniya">Vavuniya</option>
    
        </select>

        <label for="vehicle-registration">Vehicle Registration Number:</label>
        <input type="text" id="vehicle-registration" name="vehicle-registration" required>

        <label for="current-mileage">Current Mileage:</label>
        <input type="number" id="current-mileage" name="current-mileage" required>

        <label for="message">Message:</label>
        <textarea id="message" name="message"></textarea>
        
       

        <button type="submit" name="submit">Submit</button>
    </form>
    </section>
    


<script>
var dateInput = document.getElementById('date');

//Function to check if a given date is a Sunday
function isSunday(date) {
 return date.getDay() === 0; // Sunday is 0 in JavaScript's date.getDay()
}

//Set the minimum value of the date input to the current day
var currentDate = new Date().toISOString().split('T')[0]; // Get the current date in YYYY-MM-DD format
dateInput.min = currentDate;

//Function to validate the date input
function validateDate() {
 var selectedDate = new Date(dateInput.value);
 var currentDate = new Date();
 
 // Check if the selected date is a Sunday or earlier than the current date
 if (isSunday(selectedDate) || selectedDate < currentDate) {
     document.getElementById('date-error').innerText = 'Please select a valid date (after today and not a Sunday).';
     dateInput.value = ''; // Clear the invalid date
 } else {
     document.getElementById('date-error').innerText = ''; // Clear the error message
 }
}

//Add an event listener to the date input to trigger validation on change
dateInput.addEventListener('change', validateDate);
</script>
   
   </body>

    