<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entites.reservations_package.Reservation"%>
<%@page import="entites.reservations_package.ReservationStatus"%>
<%@page import="entites.customers_package.Customer"%>
<%@page import="entites.tables_package.Table"%>
<%@page import="entites.employees_package.Employee"%>
<%@page import="java.util.List"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.util.Collections"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
Reservation reservation = (Reservation) request.getAttribute("reservation");
List<Customer> customers = (List<Customer>) request.getAttribute("customers");
List<Table> tables = (List<Table>) request.getAttribute("tables");
List<Employee> employees = (List<Employee>) request.getAttribute("employees");
ReservationStatus[] statuses = ReservationStatus.values();
//Ensure lists are never null
if (customers == null) customers = Collections.emptyList();
if (tables == null) tables = Collections.emptyList();
if (employees == null) employees = Collections.emptyList();
if (statuses == null) statuses = ReservationStatus.values(); // default if null

boolean isEditMode = reservation != null && reservation.getReservationID() != null;
String error = (String) request.getAttribute("error");
String pageTitle = isEditMode ? "Edit Reservation" : "Create New Reservation";

DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");

// Get reservation date/time or use current time as default
LocalDateTime reservationDateTime = isEditMode && reservation.getReservationTime() != null ? 
    reservation.getReservationTime() : LocalDateTime.now();
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
                    <i class="bi bi-calendar-plus me-2"></i><%= pageTitle %>
                </h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="${pageContext.request.contextPath}/reservation/list" class="btn btn-sm btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Back to List
                    </a>
                </div>
            </div>

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
                    <form action="${pageContext.request.contextPath}/reservation/<%= isEditMode ? "update" : "insert" %>" 
                          method="post" class="needs-validation" novalidate>
                        
                        <% if (isEditMode) { %>
                            <input type="hidden" name="reservationId" value="<%= reservation.getReservationID() %>">
                        <% } %>
                        
                        <div class="row g-3">
                            <!-- Customer Selection -->
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <select class="form-select" id="customerId" name="customerId" required>
                                        <option value="">Select a customer</option>
                                        <% for (Customer customer : customers) { 
                                            boolean selected = isEditMode && reservation.getCustomer() != null && 
                                                reservation.getCustomer().getId().equals(customer.getId());
                                        %>
                                            <option value="<%= customer.getId() %>" <%= selected ? "selected" : "" %>>
                                                <%= customer.getName() %> (<%= customer.getId() %>)
                                            </option>
                                        <% } %>
                                    </select>
                                    <label for="customerId">Customer</label>
                                    <div class="invalid-feedback">
                                        Please select a customer.
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Table Selection -->
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <select class="form-select" id="tableId" name="tableId" required>
                                        <option value="">Select a table</option>
                                        <% for (Table table : tables) { 
                                            boolean selected = isEditMode && reservation.getTable() != null && 
                                                reservation.getTable().getTableID().equals(table.getTableID());
                                        %>
                                            <option value="<%= table.getTableID() %>" <%= selected ? "selected" : "" %>
                                                data-capacity="<%= table.getMaxCapacity() %>">
                                                Table <%= table.getLocationIdentifier() %> (Capacity: <%= table.getMaxCapacity() %>)
                                            </option>
                                        <% } %>
                                    </select>
                                    <label for="tableId">Table</label>
                                    <div class="invalid-feedback">
                                        Please select a table.
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Date and Time -->
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <input type="date" class="form-control" id="reservationDate" name="reservationDate" 
                                           value="<%= reservationDateTime.format(dateFormatter) %>" 
                                           min="<%= LocalDateTime.now().format(dateFormatter) %>"
                                           required>
                                    <label for="reservationDate">Reservation Date</label>
                                    <div class="invalid-feedback">
                                        Please select a valid future date.
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <input type="time" class="form-control" id="reservationTime" name="reservationTime" 
                                           value="<%= reservationDateTime.format(timeFormatter) %>" 
                                           min="09:00" max="23:00"
                                           required>
                                    <label for="reservationTime">Reservation Time</label>
                                    <div class="invalid-feedback">
                                        Please select a time between 9:00 AM and 11:00 PM.
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Party Size -->
                            <div class="col-md-4">
                                <div class="form-floating mb-3">
                                    <input type="number" class="form-control" id="partySize" name="partySize" 
                                           min="1" max="20" 
                                           value="<%= isEditMode ? reservation.getPartySize() : "2" %>" 
                                           required>
                                    <label for="partySize">Party Size</label>
                                    <div class="invalid-feedback">
                                        Please enter a valid party size (1-20).
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Staff Selection -->
                            <div class="col-md-4">
                                <div class="form-floating mb-3">
                                    <select class="form-select" id="employeeId" name="employeeId" required>
                                        <option value="">Select staff</option>
                                        <% for (Employee employee : employees) { 
                                            boolean selected = isEditMode && reservation.getCreatedBy() != null && 
                                                reservation.getCreatedBy().getId().equals(employee.getId());
                                        %>
                                            <option value="<%= employee.getId() %>" <%= selected ? "selected" : "" %>>
                                                <%= employee.getName() %> (<%= employee.getClass().getSimpleName() %>)
                                            </option>
                                        <% } %>
                                    </select>
                                    <label for="employeeId">Staff Member</label>
                                    <div class="invalid-feedback">
                                        Please select a staff member.
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Status -->
                            <div class="col-md-4">
                                <div class="form-floating mb-3">
                                    <select class="form-select" id="status" name="status" required>
                                        <% for (ReservationStatus status : statuses) { 
                                            boolean selected = isEditMode && reservation.getStatus() != null && 
                                                reservation.getStatus() == status;
                                        %>
                                            <option value="<%= status.name() %>" <%= selected ? "selected" : "" %>>
                                                <%= status %>
                                            </option>
                                        <% } %>
                                    </select>
                                    <label for="status">Status</label>
                                    <div class="invalid-feedback">
                                        Please select a status.
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Special Requests -->
                            <div class="col-12">
                                <div class="form-floating mb-3">
                                    <textarea class="form-control" id="specialRequests" name="specialRequests" 
                                              placeholder="Special requests" 
                                              maxlength="500"
                                              style="height: 100px"><%= isEditMode && reservation.getSpecialRequests() != null ? 
                                                  reservation.getSpecialRequests() : "" %></textarea>
                                    <label for="specialRequests">Special Requests (max 500 characters)</label>
                                </div>
                            </div>
                            
                            <!-- Form Actions -->
                            <div class="col-12 mt-4">
                                <div class="d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/reservation/list" 
                                       class="btn btn-outline-secondary">
                                        <i class="bi bi-arrow-left me-1"></i> Back to List
                                    </a>
                                    <div>
                                        <button type="reset" class="btn btn-outline-danger me-2">
                                            <i class="bi bi-eraser me-1"></i> Reset
                                        </button>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="bi bi-save me-1"></i> <%= isEditMode ? "Update" : "Create" %> Reservation
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
                                <h5 class="mb-1">Delete this reservation</h5>
                                <p class="mb-0">All related data will be permanently removed.</p>
                            </div>
                            <button class="btn btn-outline-danger delete-btn"
                                    data-id="<%= reservation.getReservationID() %>"
                                    data-name="<%= reservation.getCustomer() != null ? reservation.getCustomer().getName() : "Reservation" %>">
                                <i class="bi bi-trash me-1"></i> Delete
                            </button>
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
                                <p>Are you sure you want to delete the reservation for <strong id="reservationToDelete"></strong>?</p>
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

    // Update party size max based on selected table capacity
    const tableSelect = document.getElementById('tableId');
    const partySizeInput = document.getElementById('partySize');
    
    tableSelect.addEventListener('change', function() {
        const selectedOption = this.options[this.selectedIndex];
        if (selectedOption.value) {
            const capacity = parseInt(selectedOption.getAttribute('data-capacity'));
            partySizeInput.setAttribute('max', capacity);
        }
    });
    
    // Initialize with selected table's capacity if in edit mode
    <% if (isEditMode) { %>
        const selectedTable = document.querySelector('#tableId option[selected]');
        if (selectedTable) {
            const capacity = parseInt(selectedTable.getAttribute('data-capacity'));
            partySizeInput.setAttribute('max', capacity);
        }
    <% } %>
    
    // Delete confirmation modal
    <% if (isEditMode) { %>
        const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
        const deleteId = document.getElementById('deleteId');
        const reservationToDelete = document.getElementById('reservationToDelete');
        
        document.querySelector('.delete-btn').addEventListener('click', function() {
            const id = this.getAttribute('data-id');
            const name = this.getAttribute('data-name');
            deleteId.value = id;
            reservationToDelete.textContent = name;
            deleteModal.show();
        });
    <% } %>
});
</script>