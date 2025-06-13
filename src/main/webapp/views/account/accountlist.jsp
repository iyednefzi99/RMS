<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="entites.accounts_package.Account"%>
<%@page import="entites.accounts_package.AccountStatus"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
List<Account> accounts = (List<Account>) request.getAttribute("accounts");
boolean showDeleted = request.getAttribute("showDeleted") != null;
DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
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
                    <i class="bi bi-person-badge me-2"></i>
                    <c:out value="<%= showDeleted ? \"Deleted Accounts\" : \"Account Management\" %>" />
                </h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="${pageContext.request.contextPath}/account/new" class="btn btn-sm btn-primary me-2">
                        <i class="bi bi-plus-circle me-1"></i> Add New
                    </a>
                    <c:choose>
                        <c:when test="<%= showDeleted %>">
                            <a href="${pageContext.request.contextPath}/account/list" class="btn btn-sm btn-outline-secondary">
                                <i class="bi bi-arrow-left me-1"></i> Back to Active
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/account/deleted" class="btn btn-sm btn-outline-secondary">
                                <i class="bi bi-trash me-1"></i> View Deleted
                            </a>
                        </c:otherwise>
                    </c:choose>
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
                <div class="card-body">
                    <c:choose>
                        <c:when test="<%= accounts == null || accounts.isEmpty() %>">
                            <div class="text-center py-5">
                                <i class="bi bi-person-x-fill text-muted" style="font-size: 3rem;"></i>
                                <h3 class="h5 mt-3">
                                    <c:out value="<%= showDeleted ? \"No deleted accounts found\" : \"No accounts found\" %>" />
                                </h3>
                                <p class="text-muted">
                                    <c:out value="<%= showDeleted ? \"\" : \"Get started by creating a new account\" %>" />
                                </p>
                                <c:if test="<%= !showDeleted %>">
                                    <a href="${pageContext.request.contextPath}/account/new" class="btn btn-primary mt-3">
                                        <i class="bi bi-plus-circle me-1"></i> Create Account
                                    </a>
                                </c:if>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th><i class="bi bi-person me-1"></i> Username</th>
                                            <th><i class="bi bi-envelope me-1"></i> Email</th>
                                            <th><i class="bi bi-circle-fill me-1"></i> Status</th>
                                            <c:if test="<%= showDeleted %>">
                                                <th><i class="bi bi-clock me-1"></i> Deleted On</th>
                                            </c:if>
                                            <th class="text-end"><i class="bi bi-gear me-1"></i> Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="<%= accounts %>" var="account">
                                            <tr>
                                                <td class="fw-semibold"><c:out value="${account.username}" /></td>
                                                <td><c:out value="${account.email}" /></td>
                                                <td>
                                                    <span class="badge ${AccountStatus.getStatusBadgeClass(account.status)} rounded-pill">
                                                        <i class="bi ${AccountStatus.getStatusIcon(account.status)} me-1"></i>
                                                        <c:out value="${account.status}" />
                                                    </span>
                                                </td>
                                                <c:if test="<%= showDeleted %>">
                                                    <td>
                                                        <c:out value="${account.deletedAt != null ? account.deletedAt.format(dateFormatter) : 'Unknown'}" />
                                                    </td>
                                                </c:if>
                                                <td class="text-end">
                                                    <div class="btn-group btn-group-sm">
                                                        <c:choose>
                                                            <c:when test="<%= !showDeleted %>">
                                                                <a href="${pageContext.request.contextPath}/account/edit?username=${account.username}" 
                                                                   class="btn btn-outline-primary"
                                                                   data-bs-toggle="tooltip" title="Edit">
                                                                    <i class="bi bi-pencil-square"></i>
                                                                </a>
                                                                <button type="button" 
                                                                        class="btn btn-outline-danger confirm-delete"
                                                                        data-bs-toggle="tooltip" 
                                                                        title="Delete"
                                                                        data-username="${account.username}">
                                                                    <i class="bi bi-trash"></i>
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" 
                                                                        class="btn btn-outline-success confirm-restore"
                                                                        data-bs-toggle="tooltip" 
                                                                        title="Restore"
                                                                        data-username="${account.username}">
                                                                    <i class="bi bi-arrow-counterclockwise"></i>
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
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
                <p>Are you sure you want to delete the account <strong id="accountToDelete"></strong>?</p>
                <p class="text-danger">This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/account/delete">
                    <input type="hidden" name="username" id="deleteUsername">
                    <button type="submit" class="btn btn-danger">
                        <i class="bi bi-trash me-1"></i> Delete
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Restore Confirmation Modal -->
<div class="modal fade" id="restoreModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title">
                    <i class="bi bi-check-circle me-1"></i> Confirm Restoration
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to restore the account <strong id="accountToRestore"></strong>?</p>
                <p class="text-success">The account will be reactivated with ACTIVE status.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <form id="restoreForm" method="post" action="${pageContext.request.contextPath}/account/restore">
                    <input type="hidden" name="username" id="restoreUsername">
                    <button type="submit" class="btn btn-success">
                        <i class="bi bi-arrow-counterclockwise me-1"></i> Restore
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    
    // Delete confirmation modal
    const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
    const deleteUsername = document.getElementById('deleteUsername');
    const accountToDelete = document.getElementById('accountToDelete');
    
    document.querySelectorAll('.confirm-delete').forEach(btn => {
        btn.addEventListener('click', function() {
            const username = this.getAttribute('data-username');
            deleteUsername.value = username;
            accountToDelete.textContent = username;
            deleteModal.show();
        });
    });
    
    // Restore confirmation modal
    const restoreModal = new bootstrap.Modal(document.getElementById('restoreModal'));
    const restoreUsername = document.getElementById('restoreUsername');
    const accountToRestore = document.getElementById('accountToRestore');
    
    document.querySelectorAll('.confirm-restore').forEach(btn => {
        btn.addEventListener('click', function() {
            const username = this.getAttribute('data-username');
            restoreUsername.value = username;
            accountToRestore.textContent = username;
            restoreModal.show();
        });
    });
});
</script>

<%@include file="/templates/footer.jsp"%>