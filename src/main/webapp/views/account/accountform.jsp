<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entites.accounts_package.Account"%>
<%@page import="entites.accounts_package.AccountStatus"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
Account account = (Account) request.getAttribute("account");
 AccountStatus currentStatus = (AccountStatus) pageContext.getAttribute("status"); 
boolean isEditMode = account != null && account.getUsername() != null;
String pageTitle = isEditMode ? "Edit Account" : "Create New Account";
%>



<%@include file="/templates/header.jsp" %>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
            <%@include file="/templates/sidebar.jsp" %>
      

        <!-- Main Content -->
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 bg-light">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">
                    <i class="bi bi-person-badge me-2"></i><%= pageTitle %>
                </h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="${pageContext.request.contextPath}/account/list" class="btn btn-sm btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Back to List
                    </a>
                </div>
            </div>

            <!-- Success Message -->
            <c:if test="${not empty sessionScope.success}">
                <div class="alert alert-success alert-dismissible fade show mb-4">
                    <i class="bi bi-check-circle-fill me-2"></i>
                    <c:out value="${sessionScope.success}" />
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="success" scope="session" />
            </c:if>

            <!-- Error Message -->
            <c:if test="${not empty requestScope.error}">
                <div class="alert alert-danger alert-dismissible fade show mb-4">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    <c:out value="${requestScope.error}" />
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white">
                    <h3 class="card-title mb-0">
                        <i class="bi bi-person-badge me-2"></i>Account Details
                    </h3>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/account/<%= isEditMode ? "update" : "insert" %>" 
                          method="post" class="needs-validation" novalidate>
                        
                        <c:if test="<%= isEditMode %>">
                            <input type="hidden" name="username" value="<c:out value="<%= account.getUsername() %>" />">
                        </c:if>
                        
                        <div class="row g-3">
                            <!-- Username Field -->
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <input type="text" 
                                           class="form-control <%= isEditMode ? "bg-light" : "" %>" 
                                           id="username" name="username" 
                                           value="<c:out value="<%= account != null ? account.getUsername() : \"\" %>" />"
                                           <%= isEditMode ? "readonly" : "required" %>
                                           pattern="[a-zA-Z0-9]{4,20}"
                                           placeholder="Username">
                                    <label for="username">Username</label>
                                    <div class="invalid-feedback">
                                        Please provide a valid username (4-20 alphanumeric characters).
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Email Field -->
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <input type="email" 
                                           class="form-control" 
                                           id="email" name="email" 
                                           value="<c:out value="<%= account != null ? account.getEmail() : \"\" %>" />" 
                                           required
                                           pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$"
                                           placeholder="Email">
                                    <label for="email">Email</label>
                                    <div class="invalid-feedback">
                                        Please provide a valid email address.
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Password Field -->
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <div class="input-group">
                                        <input type="password" 
                                               class="form-control" 
                                               id="password" name="password" 
                                               <%= isEditMode ? "" : "required" %>
                                               pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$"
                                               placeholder="Password">
                                        <button class="btn btn-outline-secondary" type="button" onclick="togglePasswordVisibility()">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                        <label for="password"></label>
                                    </div>
                                    <div class="invalid-feedback">
                                        <%= isEditMode ? "Leave blank to keep current password" : 
                                        "Password must contain uppercase, lowercase and number" %>
                                    </div>
                                    <c:if test="<%= !isEditMode %>">
                                        <div class="mt-2">
                                            <div class="d-flex justify-content-between">
                                                <small class="text-muted">Password strength</small>
                                                <small id="strength-text" class="text-muted">Weak</small>
                                            </div>
                                            <div class="progress" style="height: 5px;">
                                                <div id="password-strength" class="progress-bar" role="progressbar" style="width: 0%"></div>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <!-- Status Field -->
<div class="col-md-6">
    <div class="form-floating mb-3">
        <select class="form-select" id="status" name="status" required>
            <c:forEach items="<%= AccountStatus.values() %>" var="status">
                <option value="${status.name()}" 
                    ${account != null && account.getStatus() == status ? 'selected' : ''}>
                    <c:out value="${status.name()}" />
                </option>
            </c:forEach>
        </select>
        <label for="status">Status</label>
    </div>
</div>
                            <!-- Form Actions -->
                            <div class="col-12">
                                <div class="d-flex justify-content-between mt-4">
                                    <button type="reset" class="btn btn-outline-danger">
                                        <i class="bi bi-eraser me-1"></i> Reset
                                    </button>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-save me-1"></i> Save Account
                                    </button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- Danger Zone (Edit Mode Only) -->
            <c:if test="<%= isEditMode %>">
                <div class="card border-danger shadow-sm">
                    <div class="card-header bg-danger text-white">
                        <h3 class="card-title mb-0">
                            <i class="bi bi-exclamation-triangle me-2"></i>Danger Zone
                        </h3>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h5 class="mb-1">Delete this account</h5>
                                <p class="mb-0 text-muted">Once deleted, this account cannot be recovered.</p>
                            </div>
                            <button class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteModal">
                                <i class="bi bi-trash me-1"></i> Delete Account
                            </button>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<c:if test="<%= isEditMode %>">
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">
                    <i class="bi bi-exclamation-triangle me-1"></i> Confirm Deletion
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to permanently delete this account (<strong><c:out value="<%= account.getUsername() %>" /></strong>)?</p>
                <p class="text-danger">This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <form action="${pageContext.request.contextPath}/account/delete" method="post">
                    <input type="hidden" name="username" value="<c:out value="<%= account.getUsername() %>" />">
                    <button type="submit" class="btn btn-danger">
                        <i class="bi bi-trash me-1"></i> Delete Permanently
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>
</c:if>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Form validation
    const forms = document.querySelectorAll('.needs-validation');
    
    Array.from(forms).forEach(function(form) {
        form.addEventListener('submit', function(event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    });
    
    // Password strength meter
    <c:if test="<%= !isEditMode %>">
    const passwordInput = document.getElementById('password');
    const strengthBar = document.getElementById('password-strength');
    const strengthText = document.getElementById('strength-text');
    
    if (passwordInput && strengthBar) {
        passwordInput.addEventListener('input', function() {
            const password = this.value;
            let strength = 0;
            
            // Length check
            if (password.length >= 8) strength += 25;
            
            // Complexity checks
            if (/[A-Z]/.test(password)) strength += 25;
            if (/[a-z]/.test(password)) strength += 25;
            if (/\d/.test(password)) strength += 25;
            
            // Update progress bar
            strengthBar.style.width = strength + '%';
            
            // Update text and color
            if (strength < 50) {
                strengthBar.className = 'progress-bar bg-danger';
                strengthText.textContent = 'Weak';
                strengthText.className = 'text-danger';
            } else if (strength < 75) {
                strengthBar.className = 'progress-bar bg-warning';
                strengthText.textContent = 'Medium';
                strengthText.className = 'text-warning';
            } else {
                strengthBar.className = 'progress-bar bg-success';
                strengthText.textContent = 'Strong';
                strengthText.className = 'text-success';
            }
        });
    }
    </c:if>
    
    // Toggle password visibility
    window.togglePasswordVisibility = function() {
        const passwordField = document.getElementById('password');
        const icon = document.querySelector('.bi-eye');
        if (passwordField.type === 'password') {
            passwordField.type = 'text';
            icon.classList.replace('bi-eye', 'bi-eye-slash');
        } else {
            passwordField.type = 'password';
            icon.classList.replace('bi-eye-slash', 'bi-eye');
        }
    };
});
</script>

<%@include file="/templates/footer.jsp"%>