<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entites.employees_package.Employee"%>
<%@page import="entites.employees_package.Waiter"%>
<%@page import="entites.employees_package.Receptionist"%>
<%@page import="entites.employees_package.Manager"%>
<%@page import="entites.accounts_package.Account"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@page import="java.time.format.DateTimeFormatter"%>

<%
List<Employee> employees = Collections.emptyList();
Object employeesAttr = request.getAttribute("employees");
if (employeesAttr instanceof List) {
    @SuppressWarnings("unchecked")
    List<Employee> temp = (List<Employee>) employeesAttr;
    employees = temp;
}
DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
%>

<%@include file="/templates/header.jsp" %>

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <h2 class="mb-0">
                            <i class="bi bi-people-fill me-2"></i>Employee Management
                        </h2>
                        <a href="${pageContext.request.contextPath}/employee/new" class="btn btn-light">
                            <i class="bi bi-plus-circle me-1"></i> Add New
                        </a>
                    </div>
                </div>
                
                <div class="card-body">
                    <%@include file="/templates/alerts.jsp" %>
                    
                    <% if (employees.isEmpty()) { %>
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle-fill me-2"></i>No employees found
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
                                        <th><i class="bi bi-tag me-1"></i> Role</th>
                                        <th><i class="bi bi-calendar-date me-1"></i> Date Joined</th>
                                        <th class="text-end"><i class="bi bi-gear me-1"></i> Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Employee employee : employees) { 
                                        String roleBadgeClass = "";
                                        String roleIcon = "";
                                        
                                        if (employee instanceof Waiter) {
                                            roleBadgeClass = "bg-info text-dark";
                                            roleIcon = "bi-cup-straw";
                                        } else if (employee instanceof Receptionist) {
                                            roleBadgeClass = "bg-primary text-white";
                                            roleIcon = "bi-headset";
                                        } else if (employee instanceof Manager) {
                                            roleBadgeClass = "bg-success text-white";
                                            roleIcon = "bi-award";
                                        }
                                    %>
                                        <tr>
                                            <td class="fw-semibold"><%= employee.getId() %></td>
                                            <td><%= employee.getName() %></td>
                                            <td><%= employee.getPhone() %></td>
                                            <td>
                                                <% if (employee.getAccount() != null) { %>
                                                    <span class="badge bg-secondary">
                                                        <i class="bi bi-person-check me-1"></i>
                                                        <%= employee.getAccount().getUsername() %>
                                                    </span>
                                                <% } %>
                                            </td>
                                            <td>
                                                <span class="badge <%= roleBadgeClass %> rounded-pill">
                                                    <i class="bi <%= roleIcon %> me-1"></i>
                                                    <%= employee.getRole() %>
                                                </span>
                                            </td>
                                            <td><%= employee.getDateJoined().format(dateFormatter) %></td>
                                            <td class="text-end">
                                                <div class="btn-group btn-group-sm" role="group">
                                                    <a href="${pageContext.request.contextPath}/employee/edit?id=<%= employee.getId() %>" 
                                                       class="btn btn-outline-primary"
                                                       data-bs-toggle="tooltip" title="Edit">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </a>
                                                    <button type="button" 
                                                            class="btn btn-outline-danger delete-btn"
                                                            data-id="<%= employee.getId() %>"
                                                            data-name="<%= employee.getName() %>"
                                                            data-url="${pageContext.request.contextPath}/employee/delete?id=<%= employee.getId() %>"
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