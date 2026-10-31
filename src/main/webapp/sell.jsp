<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ include file="navbar.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Sell Product</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

<style>
    html, body {
        height: 100%;
        margin: 0;
        font-family: 'Poppins', sans-serif;
        background: linear-gradient(135deg, #dbeafe, #ffffff);
        overflow: hidden;
    }

    .content {
        display: flex;
        justify-content: center;
        align-items: center;
        height: calc(100% - 120px); /* Adjust for header/footer */
        padding: 20px;
        box-sizing: border-box;
    }

    .sell-box {
        width: 95%;
        max-width: 1100px;
        background: #fff;
        padding: 30px 40px;
        border-radius: 15px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        animation: fadeIn 0.8s ease-in-out;
        overflow-y: auto;
        max-height: 100%;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(30px); }
        to { opacity: 1; transform: translateY(0); }
    }

    h3 {
        text-align: center;
        color: #0d6efd;
        margin-bottom: 25px;
        font-weight: 600;
    }

    form {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 20px 30px;
    }

    label {
        font-size: 14px;
        font-weight: 500;
        margin-bottom: 5px;
        display: block;
    }

    input, select, textarea {
        width: 100%;
        padding: 8px 12px;
        border-radius: 8px;
        border: 1px solid #ccc;
        font-size: 14px;
        transition: all 0.3s ease;
        background-color: #f8f9fa;
    }

    input:focus, select:focus, textarea:focus {
        border-color: #0d6efd;
        box-shadow: 0 0 6px rgba(13,110,253,0.2);
        transform: scale(1.01);
        background-color: #fff;
    }

    /* Stylish Dropdowns */
    select {
        background: url("data:image/svg+xml,<svg fill='gray' height='24' viewBox='0 0 24 24' width='24' xmlns='http://www.w3.org/2000/svg'><path d='M7 10l5 5 5-5z'/></svg>") no-repeat right 12px center;
        background-size: 18px;
        appearance: none;
    }

    textarea {
        resize: none;
        height: 60px;
    }

    .full-width {
        grid-column: 1 / 4;
    }

    .char-count {
        font-size: 12px;
        text-align: right;
        color: #6c757d;
        margin-top: -10px;
        grid-column: 3 / 4;
    }

    .char-count.full {
        color: red;
        font-weight: 600;
    }

    .btn-submit {
        grid-column: 1 / 4;
        background: #0d6efd;
        color: white;
        border: none;
        padding: 12px;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.4s ease;
        animation: slideInBtn 1s ease-out;
    }

    .btn-submit:hover {
        background: #084298;
        transform: scale(1.03);
        box-shadow: 0 4px 12px rgba(13,110,253,0.3);
    }

    @keyframes slideInBtn {
        from { transform: translateX(100px); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
</style>
</head>
<body>

<div class="content">
    <div class="sell-box">
        <h3><i class="bi bi-bag-plus"></i> Sell Your Product</h3>

        <form action="sell" method="post" enctype="multipart/form-data" id="sellForm" onsubmit="showPopup(event)">
            <div>
                <label>Product Name</label>
                <input type="text" name="name" placeholder="Enter product name" required>
            </div>

            <div>
                <label>Category</label>
                <select name="category" required>
                    <option value="" disabled selected>Select category</option>
                    <option value="Electronics"> Electronics</option>
                    <option value="Clothing">Clothing</option>
                    <option value="Home & Living">Home & Living</option>
                    <option value="Books"> Books</option>
                    <option value="Groceries"> Groceries</option>
                    <option value="Beauty">Beauty</option>
                    <option value="Sports"> Sports</option>
                </select>
            </div>

            <div>
                <label>Condition</label>
                <select name="condition" required>
                    <option value="" disabled selected>Select</option>
                    <option value="Excellent">Excellent</option>
                    <option value="Good"> Good</option>
                    <option value="Bad"> Bad</option>
                </select>
            </div>

            <div>
                <label>Price</label>
                <input type="number" name="price" placeholder="Enter price" required>
            </div>
            
            <div>
                <label>Email</label>
                <input type="email" name="email" placeholder="Enter email" required>
            </div>

            <div class="full-width">
                <label>Address</label>
                <textarea name="address" placeholder="Enter address" required></textarea>
            </div>

            <div class="full-width">
                <label>Description</label>
                <textarea name="description" id="description" placeholder="Max 300 letters" maxlength="300" required></textarea>
            </div>

            <div class="char-count" id="charCount">0 / 300</div>

            <div class="full-width">
                <label>Upload Image</label>
                <input type="file" name="image" accept="image/*" required>
            </div>

            <button type="submit" class="btn-submit">Submit</button>
        </form>
    </div>
</div>

<%@ include file="footer.jsp" %>

<script>
function showPopup(event) {
    event.preventDefault();
    alert("Product Submitted Successfully!");
    document.getElementById("sellForm").submit();
}

const desc = document.getElementById("description");
const count = document.getElementById("charCount");

desc.addEventListener("input", () => {
    count.textContent = desc.value.length + " / 300";
    if (desc.value.length >= 300) {
        count.classList.add("full");
        count.textContent = "Limit reached (300/300)";
    } else {
        count.classList.remove("full");
    }
});
</script>

</body>
</html>
