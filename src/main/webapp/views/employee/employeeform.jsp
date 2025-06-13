<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entites.employees_package.Employee"%>
<%@page import="entites.employees_package.Waiter"%>
<%@page import="entites.employees_package.Receptionist"%>
<%@page import="entites.employees_package.Manager"%>
<%@page import="entites.accounts_package.Account"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@page import="java.time.LocalDate"%>

<%
Employee employee = (Employee) request.getAttribute("employee");
List<Account> accounts = Collections.emptyList();
Object accountsAttr = request.getAttribute("accounts");
if (accountsAttr instanceof List) {
    @SuppressWarnings("unchecked")
    List<Account> temp = (List<Account>) accountsAttr;
    accounts = temp;
}
boolean isEditMode = employee != null && employee.getId() != null;
String pageTitle = isEditMode ? "Edit Employee" : "Create New Employee";
String error = (String) request.getAttribute("error");
%>

<%@include file="/templates/header.jsp" %>

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h2 class="mb-0"><i class="bi bi-person-vcard me-2"></i><%= pageTitle %></h2>
                </div>
                
                <div class="card-body">

                    
                    <form action="${pageContext.request.contextPath}/employee/<%= isEditMode ? "update" : "insert" %>" 
                          method="post" class="needs-validation" novalidate>
                        
                        <% if (isEditMode) { %>
                            <input type="hidden" name="id" value="<%= employee.getId() %>">
                        <% } %>
                        
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <input type="text" class="form-control <%= isEditMode ? "bg-light" : "" %>" 
                                           id="id" name="id" 
                                           value="<%= employee != null ? employee.getId() : "" %>" 
                                           <%= isEditMode ? "readonly" : "required" %>
                                           pattern="[A-Za-z0-9-]{3,20}"
                                           placeholder="Employee ID">
                                    <label for="id">Employee ID</label>
                                    <div class="invalid-feedback">
                                        Please provide a valid employee ID (3-20 alphanumeric characters).
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <input type="text" class="form-control" id="name" name="name" 
                                           value="<%= employee != null ? employee.getName() : "" %>" required
                                           pattern="[A-Za-z ]{3,50}"
                                           placeholder="Full Name">
                                    <label for="name">Full Name</label>
                                    <div class="invalid-feedback">
                                        Please provide a valid name (letters only, 3-50 characters).
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <input type="tel" class="form-control" id="phone" name="phone" 
                                           value="<%= employee != null ? employee.getPhone() : "" %>" required
                                           pattern="[0-9]{10,15}"
                                           placeholder="Phone Number">
                                    <label for="phone">Phone Number</label>
                                    <div class="invalid-feedback">
                                        Please provide a valid phone number (10-15 digits).
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <input type="date" class="form-control" id="dateJoined" name="dateJoined" 
                                           value="<%= employee != null ? employee.getDateJoined().toString() : LocalDate.now().toString() %>" required
                                           placeholder="Date Joined">
                                    <label for="dateJoined">Date Joined</label>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <select class="form-select" id="accountUsername" name="accountUsername" <%= isEditMode ? "required" : "" %>>
                                        <option value="">Select an account</option>
                                        <% for (Account account : accounts) { 
                                            boolean selected = employee != null && 
                                                employee.getAccount() != null && 
                                                employee.getAccount().getUsername().equals(account.getUsername());
                                        %>
                                            <option value="<%= account.getUsername() %>" <%= selected ? "selected" : "" %>>
                                                <%= account.getUsername() %> (<%= account.getEmail() %>)
                                            </option>
                                        <% } %>
                                    </select>
                                    <label for="accountUsername">Account</label>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <select class="form-select" id="role" name="role" required>
                                        <option value="">Select a role</option>
                                        <option value="WAITER" <%= employee instanceof Waiter ? "selected" : "" %>>Waiter</option>
                                        <option value="RECEPTIONIST" <%= employee instanceof Receptionist ? "selected" : "" %>>Receptionist</option>
                                        <option value="MANAGER" <%= employee instanceof Manager ? "selected" : "" %>>Manager</option>
                                    </select>
                                    <label for="role">Employee Role</label>
                                </div>
                            </div>
                            
                            <div class="col-12 mt-4">
                                <div class="d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/employee/list" 
                                       class="btn btn-outline-secondary">
                                        <i class="bi bi-arrow-left me-1"></i> Back to List
                                    </a>
                                    <div>
                                        <button type="reset" class="btn btn-outline-danger me-2">
                                            <i class="bi bi-eraser me-1"></i> Reset
                                        </button>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="bi bi-save me-1"></i> <%= isEditMode ? "Update" : "Save" %>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            
            <% if (isEditMode) { %>
                <div class="card shadow-sm border-danger mt-4">
                    <div class="card-header bg-danger text-white">
                        <h3 class="mb-0"><i class="bi bi-exclamation-triangle me-2"></i>Danger Zone</h3>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h5 class="mb-1">Delete this employee</h5>
                                <p class="mb-0">All related data will be permanently removed.</p>
                            </div>
                            <button class="btn btn-outline-light delete-btn"
                                    data-id="<%= employee.getId() %>"
                                    data-name="<%= employee.getName() %>"
                                    data-url="${pageContext.request.contextPath}/employee/delete?id=<%= employee.getId() %>">
                                <i class="bi bi-trash me-1"></i> Delete
                            </button>
                        </div>
                    </div>
                </div>
                
                <%@include file="/templates/delete-modal.jsp" %>
            <% } %>
        </div>
    </div>
</div>

<%@include file="/templates/footer.jsp" %>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Form validation
    const forms = document.querySelectorAll('.needs-validation');
    forms.forEach(form => {
        form.addEventListener('submit', function(event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    });
    
    // Tooltip initialization
    const tooltips = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltips.map(el => new bootstrap.Tooltip(el));
});
</script>