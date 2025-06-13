<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error Page</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .error-container {
            margin-top: 5rem;
            max-width: 600px;
        }
        .error-icon {
            font-size: 5rem;
            color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="container error-container text-center">
        <div class="error-icon">
            <i class="bi bi-exclamation-octagon-fill"></i>
        </div>
        <h1 class="text-danger mb-4">Error Occurred</h1>
        
        <div class="card mb-4">
            <div class="card-header bg-danger text-white">
                Error Details
            </div>
            <div class="card-body text-start">
                <% if (exception != null) { %>
                    <p><strong>Exception:</strong> ${pageContext.exception}</p>
                    <p><strong>Message:</strong> ${pageContext.exception.message}</p>
                    <p><strong>Status Code:</strong> ${pageContext.errorData.statusCode}</p>
                    <p><strong>Request URI:</strong> ${pageContext.errorData.requestURI}</p>
                <% } else { %>
                    <p>An unexpected error occurred.</p>
                <% } %>
            </div>
        </div>
        
        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
            <i class="bi bi-house-door"></i> Return to Home
        </a>
    </div>

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>