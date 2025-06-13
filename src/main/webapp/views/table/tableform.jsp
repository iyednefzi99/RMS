<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entites.tables_package.Table"%>
<%@page import="entites.tables_package.TableStatus"%>
<%@page import="entites.tables_package.SeatType"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
Table table = (Table) request.getAttribute("table");
boolean isEdit = table != null;
String pageTitle = isEdit ? "Edit Table" : "Add New Table";
TableStatus[] statusValues = TableStatus.values();
SeatType[] seatTypeValues = SeatType.values();
%>

<%@include file="/templates/header.jsp" %>

<style>
    .form-card {
        border-radius: 12px;
        box-shadow: 0 6px 15px rgba(0,0,0,0.1);
        overflow: hidden;
    }
    .card-header {
        padding: 1.5rem;
        background: linear-gradient(135deg, #3a7bd5 0%, #00d2ff 100%);
    }
    .form-label {
        font-weight: 600;
        color: #495057;
        margin-bottom: 0.5rem;
    }
    .form-control, .form-select {
        border-radius: 8px;
        padding: 0.75rem 1rem;
        border: 1px solid #ced4da;
        transition: all 0.3s;
    }
    .form-control:focus, .form-select:focus {
        border-color: #86b7fe;
        box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
    }
    .btn-submit {
        background: linear-gradient(135deg, #3a7bd5 0%, #00d2ff 100%);
        border: none;
        padding: 0.5rem 1.5rem;
        font-weight: 600;
    }
    .btn-submit:hover {
        background: linear-gradient(135deg, #2c5fb3 0%, #00b7e6 100%);
        transform: translateY(-2px);
    }
    .btn-cancel {
        border: 1px solid #ced4da;
        padding: 0.5rem 1.5rem;
    }
    .icon-wrapper {
        width: 40px;
        height: 40px;
        background-color: rgba(255,255,255,0.2);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 12px;
    }
    .section-title {
        font-size: 1.1rem;
        font-weight: 600;
        color: #495057;
        margin-bottom: 1.5rem;
        padding-bottom: 0.5rem;
        border-bottom: 2px solid #f1f1f1;
    }
    .input-group-icon {
        position: absolute;
        z-index: 3;
        top: 50%;
        transform: translateY(-50%);
        left: 12px;
        color: #6c757d;
    }
    .form-group {
        position: relative;
    }
    .form-group input, .form-group select {
        padding-left: 40px;
    }
</style>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <%@include file="/templates/sidebar.jsp" %>

        <!-- Main Content -->
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 bg-light">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">
                    <i class="bi bi-table me-2"></i><%= pageTitle %>
                </h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="${pageContext.request.contextPath}/table/list" class="btn btn-sm btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Back to List
                    </a>
                </div>
            </div>

            <!-- Success/Error Messages -->
            <c:if test="${not empty sessionScope.success}">
                <div class="alert alert-success alert-dismissible fade show mb-4">
                    <i class="bi bi-check-circle-fill me-2"></i>
                    <c:out value="${sessionScope.success}" />
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="success" scope="session" />
            </c:if>
            
            <c:if test="${not empty requestScope.error}">
                <div class="alert alert-danger alert-dismissible fade show mb-4">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    <c:out value="${requestScope.error}" />
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/table/<%= isEdit ? "update" : "insert" %>" method="post">
                        <% if (isEdit) { %>
                            <input type="hidden" name="id" value="<%= table.getTableID() %>">
                        <% } %>
                        
                        <div class="mb-4">
                            <h5 class="section-title">
                                <i class="bi bi-info-circle me-2"></i>Basic Information
                            </h5>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="maxCapacity" class="form-label">
                                            <i class="bi bi-people-fill me-1"></i>Max Capacity
                                        </label>
                                        <input type="number" class="form-control" id="maxCapacity" name="maxCapacity" 
                                               value="<%= isEdit ? table.getMaxCapacity() : "" %>" required min="1">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="locationIdentifier" class="form-label">
                                            <i class="bi bi-geo-alt me-1"></i>Location Identifier
                                        </label>
                                        <input type="number" class="form-control" id="locationIdentifier" name="locationIdentifier" 
                                               value="<%= isEdit ? table.getLocationIdentifier() : "" %>" required min="0">
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-4">
                            <h5 class="section-title">
                                <i class="bi bi-gear me-2"></i>Table Configuration
                            </h5>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="status" class="form-label">
                                            <i class="bi bi-graph-up me-1"></i>Status
                                        </label>
                                        <select class="form-select" id="status" name="status" required>
                                            <% for (TableStatus status : statusValues) { %>
                                                <option value="<%= status.name() %>" 
                                                    <%= isEdit && table.getStatus() == status ? "selected" : "" %>>
                                                    <%= status %>
                                                </option>
                                            <% } %>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="seatType" class="form-label">
                                            <i class="bi bi-palette me-1"></i>Seat Type
                                        </label>
                                        <select class="form-select" id="seatType" name="seatType" required>
                                            <% for (SeatType seatType : seatTypeValues) { %>
                                                <option value="<%= seatType.name() %>" 
                                                    <%= isEdit && table.getTypeofseat() == seatType ? "selected" : "" %>>
                                                    <%= seatType %>
                                                </option>
                                            <% } %>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="d-flex justify-content-end mt-4">
                            <a href="${pageContext.request.contextPath}/table/list" class="btn btn-outline-secondary me-3">
                                <i class="bi bi-x-circle me-1"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-save me-1"></i> <%= isEdit ? "Update Table" : "Save Table" %>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Add animation to form elements
    document.addEventListener('DOMContentLoaded', function() {
        const formGroups = document.querySelectorAll('.form-group');
        
        formGroups.forEach((group, index) => {
            group.style.opacity = '0';
            group.style.transform = 'translateY(20px)';
            group.style.transition = 'all 0.4s ease ' + (index * 0.1) + 's';
            
            setTimeout(() => {
                group.style.opacity = '1';
                group.style.transform = 'translateY(0)';
            }, 100);
        });
    });
</script>

<%@include file="/templates/footer.jsp"%>