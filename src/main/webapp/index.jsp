<%@include file="/templates/header.jsp"%>

<main class="main">
  <div class="container-fluid">
    <div class="row">
      <!-- Sidebar Navigation -->
      <div class="col-md-3 col-lg-2 d-md-block sidebar collapse" style="background: linear-gradient(180deg, #2c3e50 0%, #1a252f 100%);">
        <div class="position-sticky pt-3">
          <div class="sidebar-header text-center mb-4">
            <i class="bi bi-cup-hot-fill fs-2 text-primary"></i>
            <h5 class="text-white mt-2">Gourmet Manager</h5>
          </div>
          <ul class="nav flex-column">
            <li class="nav-item">
              <a class="nav-link active" href="<%= contextPath %>/index.jsp">
                <i class="bi bi-speedometer2 me-2"></i> Dashboard
                <span class="badge bg-primary rounded-pill float-end">New</span>
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="<%= contextPath %>/account/list">
                <i class="bi bi-people me-2"></i> Accounts
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="<%= contextPath %>/customer/list">
                <i class="bi bi-person-badge me-2"></i> Customers
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="<%= contextPath %>/order/list">
                <i class="bi bi-cart me-2"></i> Orders
                <span class="badge bg-danger rounded-pill float-end">5</span>
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="<%= contextPath %>/reservation/list">
                <i class="bi bi-calendar me-2"></i> Reservations
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="<%= contextPath %>/table/list">
                <i class="bi bi-grid me-2"></i> Tables
              </a>
            </li>
          </ul>
          <div class="sidebar-footer mt-auto p-3 text-center text-white-50">
            <small>v2.1.0</small>
          </div>
        </div>
      </div>

      <!-- Main Content -->
      <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 bg-light">
        <!-- Top Bar -->
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
          <div class="d-flex align-items-center">
            <button class="btn btn-sm d-md-none me-2" type="button" data-bs-toggle="collapse" data-bs-target=".sidebar">
              <i class="bi bi-list"></i>
            </button>
            <h1 class="h4 mb-0">Dashboard Overview</h1>
          </div>
          <div class="d-flex align-items-center">
            <div class="input-group input-group-sm me-3" style="width: 200px;">
              <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
              <input type="text" class="form-control" placeholder="Search...">
            </div>
            <div class="dropdown me-2">
              <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" id="notificationsDropdown" data-bs-toggle="dropdown">
                <i class="bi bi-bell"></i>
                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">3</span>
              </button>
              <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="notificationsDropdown">
                <li><h6 class="dropdown-header">Notifications (3)</h6></li>
                <li><a class="dropdown-item" href="#">New order received</a></li>
                <li><a class="dropdown-item" href="#">Reservation confirmed</a></li>
                <li><a class="dropdown-item" href="#">System update available</a></li>
              </ul>
            </div>
            <div class="dropdown">
              <a href="#" class="d-flex align-items-center text-decoration-none dropdown-toggle" id="userDropdown" data-bs-toggle="dropdown">
                <img src="https://via.placeholder.com/30" alt="User" class="rounded-circle me-2">
                <span class="d-none d-md-inline">Admin User</span>
              </a>
              <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                <li><a class="dropdown-item" href="#"><i class="bi bi-person me-2"></i>Profile</a></li>
                <li><a class="dropdown-item" href="#"><i class="bi bi-gear me-2"></i>Settings</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="#"><i class="bi bi-box-arrow-right me-2"></i>Sign out</a></li>
              </ul>
            </div>
          </div>
        </div>

        <!-- Stats Cards -->
        <div class="row mb-4 g-4">
          <div class="col-md-6 col-lg-3">
            <div class="card card-stat border-0 shadow-sm">
              <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                  <div>
                    <h6 class="card-subtitle mb-2 text-muted">Today's Orders</h6>
                    <h2 class="card-title mb-0">24</h2>
                    <small class="text-success"><i class="bi bi-arrow-up"></i> 12% from yesterday</small>
                  </div>
                  <div class="card-icon bg-primary bg-opacity-10">
                    <i class="bi bi-cart text-primary"></i>
                  </div>
                </div>
              </div>
              <div class="card-footer bg-transparent border-top">
                <a href="<%= contextPath %>/order/list" class="text-decoration-none">View all orders <i class="bi bi-arrow-right"></i></a>
              </div>
            </div>
          </div>
          <div class="col-md-6 col-lg-3">
            <div class="card card-stat border-0 shadow-sm">
              <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                  <div>
                    <h6 class="card-subtitle mb-2 text-muted">Today's Reservations</h6>
                    <h2 class="card-title mb-0">12</h2>
                    <small class="text-success"><i class="bi bi-arrow-up"></i> 5% from yesterday</small>
                  </div>
                  <div class="card-icon bg-success bg-opacity-10">
                    <i class="bi bi-calendar text-success"></i>
                  </div>
                </div>
              </div>
              <div class="card-footer bg-transparent border-top">
                <a href="<%= contextPath %>/reservation/list" class="text-decoration-none">View all reservations <i class="bi bi-arrow-right"></i></a>
              </div>
            </div>
          </div>
          <div class="col-md-6 col-lg-3">
            <div class="card card-stat border-0 shadow-sm">
              <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                  <div>
                    <h6 class="card-subtitle mb-2 text-muted">New Customers</h6>
                    <h2 class="card-title mb-0">8</h2>
                    <small class="text-danger"><i class="bi bi-arrow-down"></i> 2% from last week</small>
                  </div>
                  <div class="card-icon bg-warning bg-opacity-10">
                    <i class="bi bi-person-plus text-warning"></i>
                  </div>
                </div>
              </div>
              <div class="card-footer bg-transparent border-top">
                <a href="<%= contextPath %>/customer/list" class="text-decoration-none">View all customers <i class="bi bi-arrow-right"></i></a>
              </div>
            </div>
          </div>
          <div class="col-md-6 col-lg-3">
            <div class="card card-stat border-0 shadow-sm">
              <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                  <div>
                    <h6 class="card-subtitle mb-2 text-muted">Pending Tasks</h6>
                    <h2 class="card-title mb-0">5</h2>
                    <small class="text-success"><i class="bi bi-arrow-up"></i> 1 new today</small>
                  </div>
                  <div class="card-icon bg-danger bg-opacity-10">
                    <i class="bi bi-list-check text-danger"></i>
                  </div>
                </div>
              </div>
              <div class="card-footer bg-transparent border-top">
                <a href="#" class="text-decoration-none">View all tasks <i class="bi bi-arrow-right"></i></a>
              </div>
            </div>
          </div>
        </div>

        <!-- Charts and Recent Activity -->
        <div class="row g-4 mb-4">
          <!-- Orders Chart -->
          <div class="col-lg-8">
            <div class="card border-0 shadow-sm h-100">
              <div class="card-header bg-white border-0 d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="bi bi-bar-chart me-2"></i>Weekly Orders</h5>
                <div class="dropdown">
                  <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" id="ordersDropdown" data-bs-toggle="dropdown">
                    This Week
                  </button>
                  <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="ordersDropdown">
                    <li><a class="dropdown-item" href="#">Today</a></li>
                    <li><a class="dropdown-item" href="#">This Week</a></li>
                    <li><a class="dropdown-item" href="#">This Month</a></li>
                    <li><a class="dropdown-item" href="#">This Year</a></li>
                  </ul>
                </div>
              </div>
              <div class="card-body">
                <canvas id="ordersChart" height="250"></canvas>
              </div>
            </div>
          </div>
          
          <!-- Table Status -->
          <div class="col-lg-4">
            <div class="card border-0 shadow-sm h-100">
              <div class="card-header bg-white border-0">
                <h5 class="mb-0"><i class="bi bi-grid me-2"></i>Table Status</h5>
              </div>
              <div class="card-body">
                <div class="text-center mb-4">
                  <canvas id="tableStatusChart" height="180"></canvas>
                </div>
                <div class="row text-center">
                  <div class="col-4">
                    <div class="p-2">
                      <h4 class="mb-0">8</h4>
                      <small class="text-muted">Available</small>
                    </div>
                  </div>
                  <div class="col-4">
                    <div class="p-2">
                      <h4 class="mb-0">3</h4>
                      <small class="text-muted">Reserved</small>
                    </div>
                  </div>
                  <div class="col-4">
                    <div class="p-2">
                      <h4 class="mb-0">2</h4>
                      <small class="text-muted">Occupied</small>
                    </div>
                  </div>
                </div>
              </div>
              <div class="card-footer bg-white border-0">
                <a href="<%= contextPath %>/table/list" class="text-decoration-none">Manage tables <i class="bi bi-arrow-right"></i></a>
              </div>
            </div>
          </div>
        </div>

        <!-- Recent Activity and Quick Actions -->
        <div class="row g-4">
          <!-- Recent Activity -->
          <div class="col-lg-8">
            <div class="card border-0 shadow-sm">
              <div class="card-header bg-white border-0 d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="bi bi-activity me-2"></i>Recent Activity</h5>
                <button class="btn btn-sm btn-outline-primary">View All</button>
              </div>
              <div class="card-body p-0">
                <div class="table-responsive">
                  <table class="table table-hover mb-0">
                    <thead class="table-light">
                      <tr>
                        <th>Time</th>
                        <th>Activity</th>
                        <th>User</th>
                        <th>Status</th>
                        <th></th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td><small class="text-muted">10:42 AM</small></td>
                        <td>New order #1245</td>
                        <td><span class="badge bg-light text-dark"><i class="bi bi-person me-1"></i>John D.</span></td>
                        <td><span class="badge bg-success bg-opacity-10 text-success">Completed</span></td>
                        <td class="text-end"><a href="#" class="btn btn-sm btn-light"><i class="bi bi-chevron-right"></i></a></td>
                      </tr>
                      <tr>
                        <td><small class="text-muted">09:15 AM</small></td>
                        <td>Table reservation #89</td>
                        <td><span class="badge bg-light text-dark"><i class="bi bi-person me-1"></i>Sarah M.</span></td>
                        <td><span class="badge bg-warning bg-opacity-10 text-warning">Pending</span></td>
                        <td class="text-end"><a href="#" class="btn btn-sm btn-light"><i class="bi bi-chevron-right"></i></a></td>
                      </tr>
                      <tr>
                        <td><small class="text-muted">Yesterday</small></td>
                        <td>New customer registered</td>
                        <td><span class="badge bg-light text-dark"><i class="bi bi-gear me-1"></i>System</span></td>
                        <td><span class="badge bg-info bg-opacity-10 text-info">New</span></td>
                        <td class="text-end"><a href="#" class="btn btn-sm btn-light"><i class="bi bi-chevron-right"></i></a></td>
                      </tr>
                      <tr>
                        <td><small class="text-muted">Yesterday</small></td>
                        <td>Menu updated</td>
                        <td><span class="badge bg-light text-dark"><i class="bi bi-person me-1"></i>Chef Taher</span></td>
                        <td><span class="badge bg-primary bg-opacity-10 text-primary">Updated</span></td>
                        <td class="text-end"><a href="#" class="btn btn-sm btn-light"><i class="bi bi-chevron-right"></i></a></td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Quick Actions -->
          <div class="col-lg-4">
            <div class="card border-0 shadow-sm">
              <div class="card-header bg-white border-0">
                <h5 class="mb-0"><i class="bi bi-lightning me-2"></i>Quick Actions</h5>
              </div>
              <div class="card-body">
                <div class="d-grid gap-3">
                  <a href="<%= contextPath %>/order/form" class="btn btn-primary btn-action">
                    <i class="bi bi-plus-circle me-2"></i>
                    <span>Create New Order</span>
                    <i class="bi bi-chevron-right ms-auto"></i>
                  </a>
                  <a href="<%= contextPath %>/reservation/form" class="btn btn-success btn-action">
                    <i class="bi bi-calendar-plus me-2"></i>
                    <span>Add Reservation</span>
                    <i class="bi bi-chevron-right ms-auto"></i>
                  </a>
                  <a href="<%= contextPath %>/customer/new" class="btn btn-info btn-action">
                    <i class="bi bi-person-plus me-2"></i>
                    <span>Add Customer</span>
                    <i class="bi bi-chevron-right ms-auto"></i>
                  </a>
                  <a href="<%= contextPath %>/account/new" class="btn btn-warning btn-action">
                    <i class="bi bi-person-plus me-2"></i>
                    <span>Create Account</span>
                    <i class="bi bi-chevron-right ms-auto"></i>
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</main>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    // Table Status Chart
    const ctx = document.getElementById('tableStatusChart').getContext('2d');
    const tableStatusChart = new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: ['Available', 'Reserved', 'Occupied'],
        datasets: [{
          data: [8, 3, 2],
          backgroundColor: [
            'rgba(40, 167, 69, 0.8)',
            'rgba(255, 193, 7, 0.8)',
            'rgba(220, 53, 69, 0.8)'
          ],
          borderColor: [
            'rgba(40, 167, 69, 1)',
            'rgba(255, 193, 7, 1)',
            'rgba(220, 53, 69, 1)'
          ],
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        cutout: '75%',
        plugins: {
          legend: {
            position: 'bottom',
            labels: {
              boxWidth: 12,
              padding: 20
            }
          }
        }
      }
    });
    
    // Orders Chart
    const ordersCtx = document.getElementById('ordersChart').getContext('2d');
    const ordersChart = new Chart(ordersCtx, {
      type: 'line',
      data: {
        labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        datasets: [{
          label: 'Orders',
          data: [12, 19, 15, 24, 22, 30, 18],
          backgroundColor: 'rgba(13, 110, 253, 0.1)',
          borderColor: 'rgba(13, 110, 253, 1)',
          borderWidth: 2,
          tension: 0.3,
          fill: true,
          pointBackgroundColor: 'rgba(13, 110, 253, 1)',
          pointRadius: 4,
          pointHoverRadius: 6
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: false
          },
          tooltip: {
            backgroundColor: '#2c3e50',
            titleFont: {
              size: 14
            },
            bodyFont: {
              size: 12
            },
            padding: 12,
            cornerRadius: 6
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            grid: {
              color: 'rgba(0, 0, 0, 0.05)'
            }
          },
          x: {
            grid: {
              display: false
            }
          }
        }
      }
    });
  });
</script>

<style>
  /* Custom CSS for the dashboard */
  .sidebar {
    min-height: 100vh;
    box-shadow: 2px 0 10px rgba(0,0,0,0.1);
  }
  
  .sidebar .nav-link {
    color: rgba(255,255,255,0.8);
    border-radius: 4px;
    margin-bottom: 4px;
    padding: 10px 15px;
    transition: all 0.3s;
  }
  
  .sidebar .nav-link:hover {
    color: #fff;
    background: rgba(255,255,255,0.1);
  }
  
  .sidebar .nav-link.active {
    color: #fff;
    background: rgba(255,255,255,0.2);
    font-weight: 500;
  }
  
  .sidebar .nav-link i {
    width: 20px;
    text-align: center;
  }
  
  .card-stat {
    border-radius: 10px;
    transition: transform 0.3s;
  }
  
  .card-stat:hover {
    transform: translateY(-5px);
  }
  
  .card-stat .card-icon {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.5rem;
  }
  
  .btn-action {
    display: flex;
    align-items: center;
    padding: 12px 15px;
    text-align: left;
    border-radius: 8px;
    transition: all 0.3s;
  }
  
  .btn-action:hover {
    transform: translateX(5px);
  }
  
  .btn-action i:first-child {
    font-size: 1.2rem;
  }
  
  .table thead th {
    border-bottom: none;
    font-weight: 500;
    text-transform: uppercase;
    font-size: 0.75rem;
    letter-spacing: 0.5px;
    color: #6c757d;
  }
  
  .badge.bg-light {
    background-color: #f8f9fa!important;
  }
</style>

<%@include file="/templates/footer.jsp"%>