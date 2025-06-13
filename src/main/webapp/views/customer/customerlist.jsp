<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entites.customers_package.Customer"%>
<%@page import="entites.customers_package.VIPCustomer"%>
<%@page import="entites.accounts_package.Account"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>

<% 
List<Customer> customers = Collections.emptyList();
Object customersAttr = request.getAttribute("customers");
if (customersAttr instanceof List) {
    @SuppressWarnings("unchecked")
    List<Customer> temp = (List<Customer>) customersAttr;
    customers = temp;
}
%>

<%@include file="/templates/header.jsp" %>  
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
     
            <%@include file="/templates/sidebar.jsp" %>


        <!-- Main Content -->
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 bg-light">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">     <h2 class="mb-0">
                            <i class="bi bi-people-fill me-2"></i>Customer Management
                        </h2>
                        <a href="${pageContext.request.contextPath}/customer/new" class="btn btn-light">
                            <i class="bi bi-plus-circle me-1"></i> Add New
                        </a>
                    </div>
          
                
                <div class="card-body">
                    <%@include file="/templates/alerts.jsp" %>
                    
                    <% if (customers.isEmpty()) { %>
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle-fill me-2"></i>No customers found
                        </div>
                    <% } else { %>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th><i class="bi bi-person-badge me-1"></i> ID</th>
                                        <th><i class="bi bi-person me-1"></i> Name</th>
                                        <th><i class="bi bi-telephone me-1"></i> Phone</th>
                                        <th><i class="bi bi-person-circle me-1"></i> Account</th>
                                        <th><i class="bi bi-tag me-1"></i> Type</th>
                                        <th><i class="bi bi-percent me-1"></i> Discount</th>
                                        <th class="text-end"><i class="bi bi-gear me-1"></i> Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Customer customer : customers) { 
                                        boolean isVip = customer instanceof VIPCustomer;
                                    %>
                                        <tr class="<%= isVip ? "table-warning" : "" %>">
                                            <td class="fw-semibold"><%= customer.getId() %></td>
                                            <td><%= customer.getName() %></td>
                                            <td><%= customer.getPhone() %></td>
                                            <td>
                                                <% if (customer.getAccount() != null) { %>
                                                    <span class="badge bg-info text-dark">
                                                        <i class="bi bi-person-check me-1"></i>
                                                        <%= customer.getAccount().getUsername() %>
                                                    </span>
                                                <% } %>
                                            </td>
                                            <td>
                                                <span class="badge <%= isVip ? "bg-warning text-dark" : "bg-secondary" %> rounded-pill">
                                                    <i class="bi <%= isVip ? "bi-star-fill" : "bi-person" %> me-1"></i>
                                                    <%= customer.getRole() %>
                                                </span>
                                            </td>
                                            <td>
                                                <% if (isVip) { %>
                                                    <span class="badge bg-success rounded-pill">
                                                        <%= ((VIPCustomer)customer).getClientDiscount() %>%
                                                    </span>
                                                <% } %>
                                            </td>
                                            <td class="text-end">
                                                <div class="btn-group btn-group-sm" role="group">
                                                    <a href="${pageContext.request.contextPath}/customer/edit?id=<%= customer.getId() %>" 
                                                       class="btn btn-outline-primary"
                                                       data-bs-toggle="tooltip" title="Edit">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </a>
                                                    <button type="button" 
                                                            class="btn btn-outline-danger delete-btn"
                                                            data-id="<%= customer.getId() %>"
                                                            data-name="<%= customer.getName() %>"
                                                            data-url="${pageContext.request.contextPath}/customer/delete?id=<%= customer.getId() %>"
                                                            data-bs-toggle="tooltip" 
                                                            title="Delete">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
 
</div>
<%@include file="/templates/delete-modal.jsp" %>


<%@include file="/templates/footer.jsp" %>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Tooltip initialization
    const tooltips = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltips.map(el => new bootstrap.Tooltip(el));
});
</script>