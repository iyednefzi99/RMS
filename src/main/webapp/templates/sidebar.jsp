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
       <style>
       
        :root {
            --header-height: 60px;
            --sidebar-width: 250px;
            --primary-dark: #1e3a8a;
            --primary-light: #3b82f6;
            --transition-speed: 0.3s;
      

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
</style>