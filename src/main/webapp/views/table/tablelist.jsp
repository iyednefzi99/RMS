<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entites.tables_package.Table"%>
<%@page import="entites.tables_package.TableStatus"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
List<Table> tables = Collections.emptyList();
Object tablesAttr = request.getAttribute("tables");
if (tablesAttr instanceof List) {
    @SuppressWarnings("unchecked")
    List<Table> temp = (List<Table>) tablesAttr;
    tables = temp;
}
String success = (String) request.getAttribute("success");
String error = (String) request.getAttribute("error");
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
                    <i class="bi bi-map me-2"></i>Restaurant Floor Plan
                </h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="${pageContext.request.contextPath}/table/new" class="btn btn-sm btn-primary me-2">
                        <i class="bi bi-plus-circle me-1"></i> Add New Table
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
                <div class="card-body">
                    <div class="restaurant-diagram">
                        <!-- Main Dining Area -->
                        <div class="dining-area">
                            <div class="area-label">Main Dining</div>
                            <div class="tables-container">
                                <% for (Table table : tables) { 
                                    if (table.getLocationIdentifier() >= 100 && table.getLocationIdentifier() < 200) { %>
                                    <div class="table-spot <%= table.getStatus().name().toLowerCase() %>" 
                                         data-bs-toggle="tooltip" 
                                         title="Table <%= table.getTableID() %> - <%= table.getStatus() %>">
                                        <span class="table-number"><%= table.getLocationIdentifier() %></span>
                                        <span class="table-capacity"><%= table.getMaxCapacity() %></span>
                                    </div>
                                <% }} %>
                            </div>
                        </div>
                        
                        <!-- Bar Area -->
                        <div class="bar-area">
                            <div class="area-label">Bar</div>
                            <div class="tables-container">
                                <% for (Table table : tables) { 
                                    if (table.getLocationIdentifier() >= 200 && table.getLocationIdentifier() < 300) { %>
                                    <div class="table-spot bar <%= table.getStatus().name().toLowerCase() %>" 
                                         data-bs-toggle="tooltip" 
                                         title="Table <%= table.getTableID() %> - <%= table.getStatus() %>">
                                        <span class="table-number"><%= table.getLocationIdentifier() %></span>
                                    </div>
                                <% }} %>
                            </div>
                        </div>
                        
                        <!-- Outdoor Area -->
                        <div class="outdoor-area">
                            <div class="area-label">Patio</div>
                            <div class="tables-container">
                                <% for (Table table : tables) { 
                                    if (table.getLocationIdentifier() >= 300) { %>
                                    <div class="table-spot outdoor <%= table.getStatus().name().toLowerCase() %>" 
                                         data-bs-toggle="tooltip" 
                                         title="Table <%= table.getTableID() %> - <%= table.getStatus() %>">
                                        <span class="table-number"><%= table.getLocationIdentifier() %></span>
                                        <span class="table-capacity"><%= table.getMaxCapacity() %></span>
                                    </div>
                                <% }} %>
                            </div>
                        </div>
                        
                        <!-- Legend -->
                        <div class="legend">
                            <div class="legend-item free">Free</div>
                            <div class="legend-item occupied">Occupied</div>
                            <div class="legend-item reserved">Reserved</div>
                            <div class="legend-item cleaning">Needs Cleaning</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Table Management Card -->
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h2 class="h4 mb-0">
                        <i class="bi bi-table me-2"></i>Table Management
                    </h2>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="<%= tables == null || tables.isEmpty() %>">
                            <div class="text-center py-5">
                                <i class="bi bi-table text-muted" style="font-size: 3rem;"></i>
                                <h3 class="h5 mt-3">No tables found</h3>
                                <p class="text-muted">Get started by creating a new table</p>
                                <a href="${pageContext.request.contextPath}/table/new" class="btn btn-primary mt-3">
                                    <i class="bi bi-plus-circle me-1"></i> Create Table
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th><i class="bi bi-hash me-1"></i> ID</th>
                                            <th><i class="bi bi-people-fill me-1"></i> Capacity</th>
                                            <th><i class="bi bi-geo-alt me-1"></i> Location</th>
                                            <th><i class="bi bi-graph-up me-1"></i> Status</th>
                                            <th><i class="bi bi-palette me-1"></i> Seat Type</th>
                                            <th class="text-end"><i class="bi bi-gear me-1"></i> Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="<%= tables %>" var="table">
                                            <tr>
                                                <td class="fw-semibold"><c:out value="${table.tableID}" /></td>
                                                <td><c:out value="${table.maxCapacity}" /></td>
                                                <td><c:out value="${table.locationIdentifier}" /></td>
                                                <td>
                                                    <span class="badge ${table.status == TableStatus.FREE ? 'bg-success' : 
                                                                      table.status == TableStatus.OCCUPIED || table.status == TableStatus.IN_SERVICE ? 'bg-danger' :
                                                                      table.status == TableStatus.RESERVED || table.status == TableStatus.BOOKED || table.status == TableStatus.RESERVED_FOR_EVENT ? 'bg-warning text-dark' :
                                                                      table.status == TableStatus.READY_FOR_CLEANING || table.status == TableStatus.BEING_CLEANED ? 'bg-info text-dark' :
                                                                      table.status == TableStatus.CANCELED || table.status == TableStatus.CHECKED_OUT ? 'bg-secondary' : 'bg-light text-dark'}">
                                                        <c:out value="${table.status}" />
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge bg-info text-dark">
                                                        <c:out value="${table.typeofseat}" />
                                                    </span>
                                                </td>
                                                <td class="text-end">
                                                    <div class="btn-group btn-group-sm">
                                                        <a href="${pageContext.request.contextPath}/table/edit?id=${table.tableID}" 
                                                           class="btn btn-outline-primary"
                                                           data-bs-toggle="tooltip" title="Edit">
                                                            <i class="bi bi-pencil-square"></i>
                                                        </a>
                                                        <button type="button" 
                                                                class="btn btn-outline-danger confirm-delete"
                                                                data-bs-toggle="tooltip" 
                                                                title="Delete"
                                                                data-id="${table.tableID}"
                                                                data-name="Table ${table.tableID}">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
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
                <p>Are you sure you want to delete <strong id="tableToDelete"></strong>?</p>
                <p class="text-danger">This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/table/delete">
                    <input type="hidden" name="id" id="deleteId">
                    <button type="submit" class="btn btn-danger">
                        <i class="bi bi-trash me-1"></i> Delete
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<style>
    /* Restaurant Diagram Styles */
    .restaurant-diagram {
        position: relative;
        height: 400px;
        background-color: #f8f9fa;
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 20px;
    }
    
    .area-label {
        font-weight: bold;
        margin-bottom: 10px;
        color: #495057;
    }
    
    .dining-area {
        position: absolute;
        top: 20px;
        left: 20px;
        right: 60%;
        bottom: 40%;
        background-color: #e9ecef;
        padding: 15px;
        border-radius: 8px;
    }
    
    .bar-area {
        position: absolute;
        top: 20px;
        left: 60%;
        right: 20px;
        bottom: 60%;
        background-color: #dee2e6;
        padding: 15px;
        border-radius: 8px;
    }
    
    .outdoor-area {
        position: absolute;
        top: 60%;
        left: 20px;
        right: 20px;
        bottom: 20px;
        background-color: #d1e7dd;
        padding: 15px;
        border-radius: 8px;
    }
    
    .tables-container {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
    }
    
    .table-spot {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        font-size: 12px;
        font-weight: bold;
        color: white;
        cursor: pointer;
        transition: all 0.3s;
    }
    
    .table-spot.free { background-color: #28a745; }
    .table-spot.occupied { background-color: #dc3545; }
    .table-spot.reserved { background-color: #ffc107; color: #212529; }
    .table-spot.in_service { background-color: #fd7e14; }
    .table-spot.ready_for_cleaning,
    .table-spot.being_cleaned { background-color: #0dcaf0; color: #212529; }
    
    .table-spot.bar {
        width: 40px;
        height: 40px;
        border-radius: 4px;
    }
    
    .table-spot.outdoor {
        background-color: #198754;
    }
    
    .table-number {
        font-size: 14px;
    }
    
    .table-capacity {
        font-size: 10px;
    }
    
    .legend {
        position: absolute;
        bottom: 10px;
        right: 10px;
        display: flex;
        gap: 10px;
        background: white;
        padding: 5px 10px;
        border-radius: 4px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    
    .legend-item {
        padding: 2px 8px;
        border-radius: 4px;
        font-size: 12px;
    }
    
    .legend-item.free { background-color: #28a745; color: white; }
    .legend-item.occupied { background-color: #dc3545; color: white; }
    .legend-item.reserved { background-color: #ffc107; color: #212529; }
    .legend-item.cleaning { background-color: #0dcaf0; color: #212529; }
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    
    // Delete confirmation modal
    const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
    const deleteId = document.getElementById('deleteId');
    const tableToDelete = document.getElementById('tableToDelete');
    
    document.querySelectorAll('.confirm-delete').forEach(btn => {
        btn.addEventListener('click', function() {
            const id = this.getAttribute('data-id');
            const name = this.getAttribute('data-name');
            deleteId.value = id;
            tableToDelete.textContent = name;
            deleteModal.show();
        });
    });
    
    // Make table spots clickable to navigate to edit page
    document.querySelectorAll('.table-spot').forEach(spot => {
        const tableId = spot.getAttribute('title').split(' ')[1];
        spot.addEventListener('click', () => {
            window.location.href = '${pageContext.request.contextPath}/table/edit?id=' + tableId;
        });
    });
});
</script>

<%@include file="/templates/footer.jsp"%>