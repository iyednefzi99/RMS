<%@page import="dao.AccountDAO"%>
<%@page import="java.util.List"%>
<%@page import="entites.accounts_package.Account"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>

<%
AccountDAO accountDAO = new AccountDAO();
List<Account> deletedAccounts = accountDAO.getDeletedAccounts();
String success = (String) session.getAttribute("success");
String error = (String) request.getAttribute("error");
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
%>

<%@include file="/templates/header.jsp" %>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-lg-12">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-dark text-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <h1 class="h4 mb-0">
                            <i class="bi bi-trash me-2" aria-hidden="true"></i> Deleted Accounts
                        </h1>
                        <a href="<%= request.getContextPath() %>/account/list" class="btn btn-outline-light">
                            <i class="bi bi-arrow-left me-1" aria-hidden="true"></i> Back to Active
                        </a>
                    </div>
                </div>
                
                <div class="card-body">
                    <%-- Success/Error Messages --%>
                    <% if (success != null) { %>
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill me-2" aria-hidden="true"></i>
                            <%= success %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <% session.removeAttribute("success"); %>
                    <% } %>
                    
                    <% if (error != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2" aria-hidden="true"></i>
                            <%= error %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    <% } %>
                    
                    <%-- Deleted Accounts Table --%>
                    <% if (deletedAccounts == null || deletedAccounts.isEmpty()) { %>
                        <div class="alert alert-info" role="alert">
                            <i class="bi bi-info-circle-fill me-2" aria-hidden="true"></i> No deleted accounts found
                        </div>
                    <% } else { %>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle" aria-label="List of deleted accounts">
                                <thead class="table-light">
                                    <tr>
                                        <th scope="col"><i class="bi bi-person me-1" aria-hidden="true"></i> Username</th>
                                        <th scope="col"><i class="bi bi-envelope me-1" aria-hidden="true"></i> Email</th>
                                        <th scope="col"><i class="bi bi-calendar me-1" aria-hidden="true"></i> Deleted On</th>
                                        <th scope="col" class="text-end"><i class="bi bi-gear me-1" aria-hidden="true"></i> Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Account account : deletedAccounts) { %>
                                        <tr>
                                            <td class="fw-semibold"><%= account.getUsername() %></td>
                                            <td><%= account.getEmail() %></td>
                                            <td>
                                                <% if (account.getDeletedAt() != null) { %>
                                                    <%= account.getDeletedAt().format(formatter) %>
                                                <% } else { %>
                                                    Unknown
                                                <% } %>
                                            </td>
                                            <td class="text-end">
                                                <div class="btn-group btn-group-sm" role="group" aria-label="Account actions">
                                                    <form method="post" action="<%= request.getContextPath() %>/account/restore" style="display: inline;">
                                                        <input type="hidden" name="username" value="<%= account.getUsername() %>">
                                                        <button type="submit" class="btn btn-outline-success"
                                                                data-bs-toggle="tooltip" 
                                                                title="Restore <%= account.getUsername() %>"
                                                                aria-label="Restore <%= account.getUsername() %>">
                                                            <i class="bi bi-arrow-counterclockwise" aria-hidden="true"></i>
                                                        </button>
                                                    </form>
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

<%@include file="/templates/footer.jsp"%>