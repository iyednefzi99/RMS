<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entites.reservations_package.Reservation"%>*
<%@page import="entites.customers_package.Customer"%>
<%@page import="entites.reservations_package.ReservationStatus"%>
<%@page import="java.util.List"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.Collections"%>

<%

List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("hh:mm a");
request.setAttribute("dateFormatter", dateFormatter);
request.setAttribute("timeFormatter", timeFormatter);

boolean showDeleted = request.getAttribute("showDeleted") != null;

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
                    <i class="bi bi-calendar-check me-2"></i>
                    <c:out value="<%= showDeleted ? \"Deleted Reservations\" : \"Reservation Management\" %>" />
                </h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="${pageContext.request.contextPath}/reservation/new" class="btn btn-sm btn-primary me-2">
                        <i class="bi bi-plus-circle me-1"></i> New Reservation
                    </a>
                    <c:choose>
                        <c:when test="<%= showDeleted %>">
                            <a href="${pageContext.request.contextPath}/reservation/list" class="btn btn-sm btn-outline-secondary">
                                <i class="bi bi-arrow-left me-1"></i> Back to Active
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/reservation/deleted" class="btn btn-sm btn-outline-secondary">
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
                        <c:when test="<%= reservations == null || reservations.isEmpty() %>">
                            <div class="text-center py-5">
                                <i class="bi bi-calendar-x text-muted" style="font-size: 3rem;"></i>
                                <h3 class="h5 mt-3">
                                    <c:out value="<%= showDeleted ? \"No deleted reservations found\" : \"No reservations found\" %>" />
                                </h3>
                                <p class="text-muted">
                                    <c:out value="<%= showDeleted ? \"\" : \"Get started by creating a new reservation\" %>" />
                                </p>
                                <c:if test="<%= !showDeleted %>">
                                    <a href="${pageContext.request.contextPath}/reservation/new" class="btn btn-primary mt-3">
                                        <i class="bi bi-plus-circle me-1"></i> Create Reservation
                                    </a>
                                </c:if>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th><i class="bi bi-hash me-1"></i> ID</th>
                                            <th><i class="bi bi-person me-1"></i> Customer</th>
                                            <th><i class="bi bi-person-badge me-1"></i> Staff</th>
                                            <th><i class="bi bi-calendar-date me-1"></i> Date/Time</th>
                                            <th><i class="bi bi-people me-1"></i> Party</th>
                                            <th><i class="bi bi-tag me-1"></i> Status</th>
                                            <th class="text-end"><i class="bi bi-gear me-1"></i> Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="<%= reservations %>" var="reservation">
                                            <tr class="${reservation.reservationTime.isBefore(LocalDateTime.now()) ? 'table-secondary' : ''}">
                                                <td class="fw-semibold"><c:out value="${reservation.reservationID}" /></td>
                                                <td><c:out value="${reservation.customer != null ? reservation.customer.name : 'N/A'}" /></td>
                                                <td><c:out value="${reservation.createdBy != null ? reservation.createdBy.name : 'N/A'}" /></td>
                                                <td>
    <c:if test="${not empty reservation.reservationTime}">
        ${reservation.reservationTime.format(dateFormatter)}
        <small class="d-block text-muted">${reservation.reservationTime.format(timeFormatter)}</small>
    </c:if>
    <c:if test="${empty reservation.reservationTime}">
        N/A
    </c:if>
</td>
                                                <td><c:out value="${reservation.partySize}" /></td>
                                                <td>
                                                    <span class="badge ${reservation.status == ReservationStatus.CONFIRMED ? 'bg-success' : 
                                                                      reservation.status == ReservationStatus.PENDING ? 'bg-warning text-dark' : 
                                                                      reservation.status == ReservationStatus.CANCELED ? 'bg-secondary' : 
                                                                      reservation.status == ReservationStatus.COMPLETED ? 'bg-info text-dark' : 
                                                                      reservation.status == ReservationStatus.NO_SHOW ? 'bg-danger' : 'bg-light text-dark'} rounded-pill">
                                                        <c:out value="${reservation.status}" />
                                                    </span>
                                                    <c:if test="${reservation.reservationTime.isBefore(LocalDateTime.now())}">
                                                        <span class="badge bg-dark rounded-pill ms-1">Past</span>
                                                    </c:if>
                                                </td>
                                                <td class="text-end">
                                                    <div class="btn-group btn-group-sm">
                                                        <c:choose>
                                                            <c:when test="<%= !showDeleted %>">
                                                                <a href="${pageContext.request.contextPath}/reservation/edit?id=${reservation.reservationID}" 
                                                                   class="btn btn-outline-primary"
                                                                   data-bs-toggle="tooltip" title="Edit">
                                                                    <i class="bi bi-pencil-square"></i>
                                                                </a>
                                                                <button type="button" 
                                                                        class="btn btn-outline-danger confirm-delete"
                                                                        data-bs-toggle="tooltip" 
                                                                        title="Delete"
                                                                        data-id="${reservation.reservationID}"
                                                                        data-name="${reservation.customer.name}"
                                                                        data-date="${reservation.reservationTime.format(dateFormatter)}">
                                                                    <i class="bi bi-trash"></i>
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" 
                                                                        class="btn btn-outline-success confirm-restore"
                                                                        data-bs-toggle="tooltip" 
                                                                        title="Restore"
                                                                        data-id="${reservation.reservationID}">
                                                                    <i class="bi bi-arrow-counterclockwise"></i>
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <a href="${pageContext.request.contextPath}/reservation/view?id=${reservation.reservationID}"
                                                           class="btn btn-outline-info"
                                                           data-bs-toggle="tooltip" 
                                                           title="View Details">
                                                            <i class="bi bi-eye"></i>
                                                        </a>
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
                <p>Are you sure you want to delete the reservation for <strong id="reservationToDelete"></strong> on <strong id="reservationDate"></strong>?</p>
                <p class="text-danger">This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/reservation/delete">
                    <input type="hidden" name="id" id="deleteId">
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
                <p>Are you sure you want to restore reservation <strong id="reservationToRestore"></strong>?</p>
                <p class="text-success">The reservation will be reactivated.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <form id="restoreForm" method="post" action="${pageContext.request.contextPath}/reservation/restore">
                    <input type="hidden" name="id" id="restoreId">
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
    const deleteId = document.getElementById('deleteId');
    const reservationToDelete = document.getElementById('reservationToDelete');
    const reservationDate = document.getElementById('reservationDate');
    
    document.querySelectorAll('.confirm-delete').forEach(btn => {
        btn.addEventListener('click', function() {
            const id = this.getAttribute('data-id');
            const name = this.getAttribute('data-name');
            const date = this.getAttribute('data-date');
            deleteId.value = id;
            reservationToDelete.textContent = name;
            reservationDate.textContent = date;
            deleteModal.show();
        });
    });
    
    // Restore confirmation modal
    const restoreModal = new bootstrap.Modal(document.getElementById('restoreModal'));
    const restoreId = document.getElementById('restoreId');
    const reservationToRestore = document.getElementById('reservationToRestore');
    
    document.querySelectorAll('.confirm-restore').forEach(btn => {
        btn.addEventListener('click', function() {
            const id = this.getAttribute('data-id');
            restoreId.value = id;
            reservationToRestore.textContent = 'ID: ' + id;
            restoreModal.show();
        });
    });
});
</script>

<%@include file="/templates/footer.jsp"%>