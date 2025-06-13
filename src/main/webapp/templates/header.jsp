<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Restaurant Management System</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    
    <!-- Google Fonts - Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/style.css">
    
    <!-- Favicon -->
    <link rel="icon" href="<%= contextPath %>/assets/images/favicon.ico" type="image/x-icon">
    
    <style>
        :root {
            --header-height: 60px;
            --sidebar-width: 250px;
            --primary-dark: #1e3a8a;
            --primary-light: #3b82f6;
            --transition-speed: 0.3s;
        }
        
        body {
            padding-top: var(--header-height);
            font-family: 'Inter', sans-serif;
        }
        
        .navbar {
            height: var(--header-height);
            background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary-light) 100%);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 0;
        }
        
        .navbar-brand {
            font-weight: 600;
            font-size: 1.25rem;
            padding: 0.5rem 1rem;
        }
        
        .navbar-brand i {
            font-size: 1.5rem;
        }
        
        .nav-link {
            padding: 0.75rem 1rem;
            font-weight: 500;
            transition: all var(--transition-speed) ease;
            position: relative;
        }
        
        .nav-link:hover, .nav-link:focus {
            background-color: rgba(255,255,255,0.1);
        }
        
        .nav-link i {
            margin-right: 0.5rem;
            font-size: 1.1rem;
        }
        
        .dropdown-menu {
            border: none;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border-radius: 0.5rem;
            padding: 0.5rem 0;
            margin-top: 0.25rem;
        }
        
        .dropdown-item {
            padding: 0.5rem 1.5rem;
            font-weight: 400;
            transition: all var(--transition-speed) ease;
        }
        
        .dropdown-item:hover, .dropdown-item:focus {
            background-color: #f8f9fa;
            color: var(--primary-dark);
        }
        
        .dropdown-header {
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            color: #6c757d;
            padding: 0.25rem 1.5rem;
        }
        
        .dropdown-divider {
            margin: 0.25rem 0;
        }
        
        .user-avatar {
            width: 32px;
            height: 32px;
            object-fit: cover;
        }
        
        .navbar-toggler {
            border: none;
            padding: 0.5rem;
            margin-right: 0.5rem;
        }
        
        .navbar-toggler:focus {
            box-shadow: none;
        }
        
        @media (max-width: 991.98px) {
            .navbar-collapse {
                background-color: var(--primary-dark);
                padding: 1rem;
                margin-top: 0.5rem;
                border-radius: 0.5rem;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }
            
            .dropdown-menu {
                margin-left: 1rem;
                width: calc(100% - 2rem);
            }
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top">
        <div class="container-fluid px-4">
            <a class="navbar-brand d-flex align-items-center" href="<%= contextPath %>/index.jsp">
                <i class="bi bi-cup-hot-fill me-2"></i>
                <span>Gourmet Manager</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="<%= contextPath %>/index.jsp">
                            <i class="bi bi-house-door"></i> Home
                        </a>
                    </li>
                    
                    <!-- Management Dropdown -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="managementDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-clipboard-data"></i> Management
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="managementDropdown">
                            <!-- Accounts -->
                            <li><h6 class="dropdown-header">Accounts</h6></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/account/list">
                                <i class="bi bi-list-ul me-2"></i>List Accounts</a></li>
                            <li><a class="dropdown-item" href="<%= contextPath %>/account/new">
                                <i class="bi bi-plus-circle me-2"></i>Create Account</a></li>
                            <li><hr class="dropdown-divider"></li>
                            
                            <!-- Customers -->
                            <li><h6 class="dropdown-header">Customers</h6></li>
                            <li><a class="dropdown-item" href="<%= contextPath %>/customer/list">
                                <i class="bi bi-list-ul me-2"></i>List Customers</a></li>
                            <li><a class="dropdown-item" href="<%= contextPath %>/customer/new">
                                <i class="bi bi-plus-circle me-2"></i>Create Customer</a></li>
                            
                            <!-- Employees -->
                            <li><h6 class="dropdown-header">Employees</h6></li>
                            <li><a class="dropdown-item" href="<%= contextPath %>/employee/list">
                                <i class="bi bi-list-ul me-2"></i>List Employees</a></li>
                            <li><a class="dropdown-item" href="<%= contextPath %>/employee/new">
                                <i class="bi bi-plus-circle me-2"></i>Create Employee</a></li>
                        </ul>
                    </li>
                    
                    <!-- Operations Dropdown -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="operationsDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-gear"></i> Operations
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="operationsDropdown">
                            <!-- Orders -->
                            <li><h6 class="dropdown-header">Orders</h6></li>
                            <li><a class="dropdown-item" href="<%= contextPath %>/order/list">
                                <i class="bi bi-list-ul me-2"></i>List Orders</a></li>
                            <li><a class="dropdown-item" href="<%= contextPath %>/order/form">
                                <i class="bi bi-plus-circle me-2"></i>Create Order</a></li>
                            <li><hr class="dropdown-divider"></li>
                            
                            <!-- Reservations -->
                            <li><h6 class="dropdown-header">Reservations</h6></li>
                            <li><a class="dropdown-item" href="<%= contextPath %>/reservation/list">
                                <i class="bi bi-list-ul me-2"></i>List Reservations</a></li>
                            <li><a class="dropdown-item" href="<%= contextPath %>/reservation/new">
                                <i class="bi bi-plus-circle me-2"></i>Create Reservation</a></li>
                        </ul>
                    </li>
                    
                    <!-- Restaurant Setup Dropdown -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="setupDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-building"></i> Setup
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="setupDropdown">
                            <!-- Tables -->
                            <li><h6 class="dropdown-header">Tables</h6></li>
                            <li><a class="dropdown-item" href="<%= contextPath %>/table/list">
                                <i class="bi bi-list-ul me-2"></i>List Tables</a></li>
                            <li><a class="dropdown-item" href="<%= contextPath %>/table/new">
                                <i class="bi bi-plus-circle me-2"></i>Create Table</a></li>
                            <li><hr class="dropdown-divider"></li>
                            
                            <!-- Reviews -->
                            <li><h6 class="dropdown-header">Reviews</h6></li>
                            <li><a class="dropdown-item" href="<%= contextPath %>/review/list">
                                <i class="bi bi-list-ul me-2"></i>List Reviews</a></li>
                            <li><a class="dropdown-item" href="<%= contextPath %>/review/form">
                                <i class="bi bi-plus-circle me-2"></i>Create Review</a></li>
                        </ul>
                    </li>
                </ul>
                
                <!-- User Section -->
                <div class="d-flex align-items-center ms-3">
                    <div class="dropdown">
                        <a href="#" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <img src="https://via.placeholder.com/32" alt="User" class="rounded-circle user-avatar me-2">
                            <span class="d-none d-lg-inline">Account</span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="#">
                                <i class="bi bi-person me-2"></i>Profile</a></li>
                            <li><a class="dropdown-item" href="#">
                                <i class="bi bi-gear me-2"></i>Settings</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="#">
                                <i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </nav>