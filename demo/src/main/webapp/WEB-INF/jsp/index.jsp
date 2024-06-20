<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Text Encryption</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
            margin: 50px auto;
            background: #fff;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }
        h1 {
            text-align: center;
            color: #333;
            font-size: 24px;
            margin-bottom: 20px;
        }
        form {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        label {
            font-size: 14px;
            color: #555;
        }
        input[type="text"] {
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        button {
            padding: 10px;
            font-size: 14px;
            color: #fff;
            background-color: #007bff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        button:hover {
            background-color: #0056b3;
        }
        .result {
            margin-top: 20px;
            padding: 10px;
            background: #e9ecef;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Encrypt Your Text</h1>
        <form id="encryptForm">
            <label for="plainText">Enter text to encrypt:</label>
            <input type="text" id="plainText" name="plainText" required>
            <button type="button" onclick="submitForm()">Encrypt</button>
        </form>
        <div id="result" class="result"></div>
    </div>
    <p>Text: ${plaintext}</p>
    <p>${ciphertextString}</p>
    
    <script>
        function submitForm() {
            const plainText = document.getElementById('plainText').value;

            fetch('/encrypt', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ plainText: plainText })
            })
            .then(response => response.json())
            .then(data => {
                document.getElementById('result').innerHTML = 
                    `<p><strong>Plain Text:</strong> ${plaintext}</p>
                     <p><strong>Encrypted Text:</strong> ${ciphertextString}</p>`;
            })
            .catch(error => {
                document.getElementById('result').innerHTML = 
                    `<p style="color: red;"><strong>Error:</strong> ${error.message}</p>`;
            });
        }
    </script>
</body>
</html>
