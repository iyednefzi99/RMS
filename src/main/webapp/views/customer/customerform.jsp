<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entites.customers_package.Customer"%>
<%@page import="entites.customers_package.VIPCustomer"%>
<%@page import="entites.accounts_package.Account"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<% 
Customer customer = (Customer) request.getAttribute("customer");
List<Account> accounts = Collections.emptyList();
Object accountsAttr = request.getAttribute("accounts");
if (accountsAttr instanceof List) {
    @SuppressWarnings("unchecked")
    List<Account> temp = (List<Account>) accountsAttr;
    accounts = temp;
}
boolean isEditMode = customer != null && customer.getId() != null;
boolean isVip = customer instanceof VIPCustomer;
int discountValue = isVip ? ((VIPCustomer)customer).getClientDiscount() : 10;
String pageTitle = isEditMode ? "Edit Customer" : "Create New Customer";
%>

<%@include file="/templates/header.jsp" %>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
     
            <%@include file="/templates/sidebar.jsp" %>


        <!-- Main Content -->
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 bg-light">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">  
               
                      
                    <h2 class="mb-0"><i class="bi bi-person-vcard me-2"></i><%= pageTitle %></h2>
       
                
                <div class="card-body">
                    <%@include file="/templates/alerts.jsp" %>
                    
                    <form action="${pageContext.request.contextPath}/customer/<%= isEditMode ? "update" : "insert" %>" 
                          method="post" class="needs-validation" novalidate>
                        
                        <% if (isEditMode) { %>
                            <input type="hidden" name="id" value="<%= customer.getId() %>">
                        <% } %>
                        
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <input type="text" class="form-control <%= isEditMode ? "bg-light" : "" %>" 
                                           id="id" name="id" 
                                           value="<%= customer != null ? customer.getId() : "" %>" 
                                           <%= isEditMode ? "readonly" : "required" %>
                                           pattern="[A-Za-z0-9-]{3,20}"
                                           placeholder="Customer ID">
                                    <label for="id">Customer ID</label>
                                    <div class="invalid-feedback">
                                        Please provide a valid customer ID (3-20 alphanumeric characters).
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <input type="text" class="form-control" id="name" name="name" 
                                           value="<%= customer != null ? customer.getName() : "" %>" required
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
                                           value="<%= customer != null ? customer.getPhone() : "" %>" required
                                           pattern="[0-9]{10,15}"
                                           placeholder="Phone Number">
                                    <label for="phone">Phone Number</label>
                                    <div class="invalid-feedback">
                                        Please provide a valid phone number (10-15 digits).
                                    </div>
                                </div>
                            </div>
                            
                            <% if (isEditMode) { %>
                                <div class="col-md-6">
                                    <div class="form-floating mb-3">
                                        <select class="form-select" id="accountUsername" name="accountUsername" required>
                                            <option value="">Select an account</option>
                                            <% for (Account account : accounts) { 
                                                boolean selected = customer.getAccount() != null && 
                                                    customer.getAccount().getUsername().equals(account.getUsername());
                                            %>
                                                <option value="<%= account.getUsername() %>" <%= selected ? "selected" : "" %>>
                                                    <%= account.getUsername() %> (<%= account.getEmail() %>)
                                                </option>
                                            <% } %>
                                        </select>
                                        <label for="accountUsername">Account</label>
                                    </div>
                                </div>
                            <% } else { %>
                                <div class="col-md-6">
                                    <div class="card mb-3">
                                        <div class="card-header bg-light">
                                            <h5 class="mb-0">Account Options</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="form-check mb-3">
                                                <input class="form-check-input" type="radio" name="accountOption" 
                                                       id="existingAccount" value="existing" checked>
                                                <label class="form-check-label" for="existingAccount">
                                                    Select existing account
                                                </label>
                                            </div>
                                            
                                            <div id="existingAccountSection">
                                                <div class="form-floating mb-3">
                                                    <select class="form-select" id="accountUsername" name="accountUsername" required>
                                                        <option value="">Select an account</option>
                                                        <% for (Account account : accounts) { %>
                                                            <option value="<%= account.getUsername() %>">
                                                                <%= account.getUsername() %> (<%= account.getEmail() %>)
                                                            </option>
                                                        <% } %>
                                                    </select>
                                                    <label for="accountUsername">Select Account</label>
                                                </div>
                                            </div>
                                            
                                            <div class="form-check mb-3">
                                                <input class="form-check-input" type="radio" name="accountOption" 
                                                       id="newAccount" value="new">
                                                <label class="form-check-label" for="newAccount">
                                                    Create new account
                                                </label>
                                            </div>
                                            
                                            <div id="newAccountSection" style="display: none;">
                                                <div class="form-floating mb-3">
                                                    <input type="text" class="form-control" id="newUsername" name="newUsername"
                                                           pattern="[A-Za-z0-9_]{3,20}" 
                                                           placeholder="Username">
                                                    <label for="newUsername">Username</label>
                                                </div>
                                                <div class="form-floating mb-3">
                                                    <input type="email" class="form-control" id="newEmail" name="newEmail"
                                                           placeholder="Email">
                                                    <label for="newEmail">Email</label>
                                                </div>
                                                <div class="form-floating mb-3">
                                                    <input type="password" class="form-control" id="newPassword" name="newPassword"
                                                           minlength="6" placeholder="Password">
                                                    <label for="newPassword">Password</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            <% } %>
                            
                            <div class="col-12">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="isVip" name="isVip" 
                                           <%= isVip ? "checked" : "" %>>
                                    <label class="form-check-label" for="isVip">
                                        <i class="bi bi-star-fill text-warning me-1"></i> VIP Customer
                                    </label>
                                </div>
                            </div>
                            
                            <div class="col-md-6" id="discountContainer" style="<%= isVip ? "" : "display: none;" %>">
                                <div class="form-floating mb-3">
                                    <div class="input-group">
                                        <input type="number" class="form-control" id="clientDiscount" name="clientDiscount" 
                                               min="0" max="50" value="<%= discountValue %>" step="1"
                                               <%= isVip ? "required" : "" %>
                                               placeholder="Discount Percentage">
                                        <span class="input-group-text">%</span>
                                    </div>
                                    <label for="clientDiscount">Discount Percentage</label>
                                </div>
                            </div>
                            
                            <div class="col-12 mt-4">
                                <div class="d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/customer/list" 
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
                                <h5 class="mb-1">Delete this customer</h5>
                                <p class="mb-0">All related data will be permanently removed.</p>
                            </div>
                            <button class="btn btn-outline-light delete-btn"
                                    data-id="<%= customer.getId() %>"
                                    data-name="<%= customer.getName() %>"
                                    data-url="${pageContext.request.contextPath}/customer/delete?id=<%= customer.getId() %>">
                                <i class="bi bi-trash me-1"></i> Delete
                            </button>
                        </div>
                    </div>
                </div>
                
                <%@include file="/templates/delete-modal.jsp" %>
            <% } %>
        </div>
    </div></div>

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

    // VIP toggle
    const vipCheckbox = document.getElementById('isVip');
    const discountContainer = document.getElementById('discountContainer');
    
    vipCheckbox.addEventListener('change', function() {
        discountContainer.style.display = this.checked ? 'block' : 'none';
        document.getElementById('clientDiscount').toggleAttribute('required', this.checked);
    });
    
    <% if (!isEditMode) { %>
        // Account option toggle
        const accountOptions = document.querySelectorAll('input[name="accountOption"]');
        accountOptions.forEach(option => {
            option.addEventListener('change', function() {
                document.getElementById('existingAccountSection').style.display = 
                    this.value === 'existing' ? 'block' : 'none';
                document.getElementById('newAccountSection').style.display = 
                    this.value === 'new' ? 'block' : 'none';
                
                // Toggle required attributes
                const existingFields = ['accountUsername'];
                const newFields = ['newUsername', 'newEmail', 'newPassword'];
                
                (this.value === 'existing' ? existingFields : newFields).forEach(field => {
                    document.getElementById(field).setAttribute('required', '');
                });
                (this.value === 'existing' ? newFields : existingFields).forEach(field => {
                    document.getElementById(field).removeAttribute('required');
                });
            });
        });
    <% } %>
});
</script>