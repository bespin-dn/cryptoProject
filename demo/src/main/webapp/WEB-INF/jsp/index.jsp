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
            word-wrap: break-word; /* 텍스트가 박스를 넘어가지 않도록 줄 바꿈 설정 */
            white-space: pre-wrap; /* 줄 바꿈과 공백을 유지 */
            overflow-wrap: break-word; /* 긴 단어나 URL이 박스를 넘지 않도록 설정 */
        }
    </style>
    <script>
        function submitEncryptForm() {
            const plainText = document.getElementById('plainText').value;
            const xhr = new XMLHttpRequest();
            xhr.open('POST', '/encrypt', true);
            xhr.setRequestHeader('Content-Type', 'application/json');
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    const response = JSON.parse(xhr.responseText);
                    document.getElementById('encryptResult').innerText = response.ciphertextString;
                    document.getElementById('ciphertext').value = response.ciphertextString;
                    document.getElementById('decryptButton').style.display = 'block';
                }
            };
            xhr.send(JSON.stringify({ plaintext: plainText }));
        }

        function submitDecryptForm() {
            const cipherText = document.getElementById('ciphertext').value;
            const xhr = new XMLHttpRequest();
            xhr.open('POST', '/decrypt', true);
            xhr.setRequestHeader('Content-Type', 'application/json');
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    const response = JSON.parse(xhr.responseText);
                    document.getElementById('decryptResult').innerText = response.plaintext;
                }
            };
            xhr.send(JSON.stringify({ ciphertext: cipherText }));
        }
    </script>
</head>
<body>
    <div class="container">
        <h1>Encrypt and Decrypt Your Text</h1>
        <form id="encryptForm">
            <label for="plainText">Enter text to encrypt:</label>
            <input type="text" id="plainText" name="plainText" required>
            <button type="button" onclick="submitEncryptForm()">Encrypt</button>
        </form>
        <div id="encryptResult" class="result"></div>
        <input type="hidden" id="ciphertext">
        <button id="decryptButton" type="button" onclick="submitDecryptForm()" style="display:none;">Decrypt</button>
        <div id="decryptResult" class="result"></div>
    </div>
</body>
</html>
