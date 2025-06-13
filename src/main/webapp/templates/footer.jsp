<footer class="footer bg-dark text-white pt-5 pb-4">
    <div class="container">
        <div class="row g-4">
            <!-- Brand Info -->
            <div class="col-lg-4">
                <div class="d-flex align-items-center mb-3">
                    <i class="bi bi-cup-hot-fill fs-2 text-primary me-2"></i>
                    <span class="h4 mb-0 fw-bold">Gourmet Manager</span>
                </div>
                <p class="text-white-50 mb-4">Streamlining restaurant operations with elegant efficiency.</p>
                <div class="social-icons">
                    <a href="#" class="text-decoration-none me-3 text-white-50 hover-primary">
                        <i class="bi bi-facebook fs-5"></i>
                    </a>
                    <a href="#" class="text-decoration-none me-3 text-white-50 hover-primary">
                        <i class="bi bi-twitter fs-5"></i>
                    </a>
                    <a href="#" class="text-decoration-none me-3 text-white-50 hover-primary">
                        <i class="bi bi-instagram fs-5"></i>
                    </a>
                    <a href="#" class="text-decoration-none text-white-50 hover-primary">
                        <i class="bi bi-linkedin fs-5"></i>
                    </a>
                </div>
            </div>

            <!-- Quick Links -->
            <div class="col-md-4 col-lg-2">
                <h5 class="mb-3 fw-bold text-primary">Quick Links</h5>
                <ul class="nav flex-column">
                    <li class="nav-item mb-2"><a href="<%= contextPath %>/index.jsp" class="nav-link p-0 text-white-50 hover-white">Home</a></li>
                    <li class="nav-item mb-2"><a href="<%= contextPath %>/account/list" class="nav-link p-0 text-white-50 hover-white">Accounts</a></li>
                    <li class="nav-item mb-2"><a href="<%= contextPath %>/customer/list" class="nav-link p-0 text-white-50 hover-white">Customers</a></li>
                    <li class="nav-item mb-2"><a href="<%= contextPath %>/order/list" class="nav-link p-0 text-white-50 hover-white">Orders</a></li>
                    <li class="nav-item mb-2"><a href="<%= contextPath %>/reservation/list" class="nav-link p-0 text-white-50 hover-white">Reservations</a></li>
                </ul>
            </div>

            <!-- Support -->
            <div class="col-md-4 col-lg-3">
                <h5 class="mb-3 fw-bold text-primary">Support</h5>
                <ul class="nav flex-column">
                    <li class="nav-item mb-2"><a href="#" class="nav-link p-0 text-white-50 hover-white">Documentation</a></li>
                    <li class="nav-item mb-2"><a href="#" class="nav-link p-0 text-white-50 hover-white">FAQs</a></li>
                    <li class="nav-item mb-2"><a href="#" class="nav-link p-0 text-white-50 hover-white">Help Center</a></li>
                    <li class="nav-item mb-2"><a href="#" class="nav-link p-0 text-white-50 hover-white">Community</a></li>
                </ul>
            </div>

            <!-- Contact -->
            <div class="col-md-4 col-lg-3">
                <h5 class="mb-3 fw-bold text-primary">Contact Us</h5>
                <ul class="nav flex-column">
                    <li class="nav-item mb-3 d-flex align-items-start">
                        <i class="bi bi-geo-alt fs-5 mt-1 me-2 text-primary"></i>
                        <span class="text-white-50">123 Restaurant St, Foodville</span>
                    </li>
                    <li class="nav-item mb-3 d-flex align-items-start">
                        <i class="bi bi-telephone fs-5 mt-1 me-2 text-primary"></i>
                        <span class="text-white-50">(555) 123-4567</span>
                    </li>
                    <li class="nav-item mb-2 d-flex align-items-start">
                        <i class="bi bi-envelope fs-5 mt-1 me-2 text-primary"></i>
                        <span class="text-white-50">support@gourmetmanager.com</span>
                    </li>
                </ul>
            </div>
        </div>

        <hr class="my-4 bg-secondary opacity-25">

        <div class="row align-items-center">
            <div class="col-md-6 text-center text-md-start mb-3 mb-md-0">
                <span class="text-white-50">&copy; 2023 Gourmet Manager. All rights reserved.</span>
            </div>
            <div class="col-md-6 text-center text-md-end">
                <a href="#" class="text-decoration-none text-white-50 hover-white me-3">Privacy Policy</a>
                <a href="#" class="text-decoration-none text-white-50 hover-white me-3">Terms of Service</a>
                <a href="#" class="text-decoration-none text-white-50 hover-white">Cookie Policy</a>
            </div>
        </div>
    </div>

    <!-- Back to Top Button -->
    <button type="button" class="btn btn-primary btn-floating btn-lg rounded-circle shadow-lg" id="btn-back-to-top">
        <i class="bi bi-arrow-up"></i>
    </button>
</footer>

<!-- Bootstrap 5 JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JS -->
<script src="${pageContext.request.contextPath}/assets/js/script.js"></script>

<script>
    // Back to top button with fade animation
    document.addEventListener('DOMContentLoaded', function() {
        const backToTopButton = document.getElementById('btn-back-to-top');
        
        // Initially hide the button
        backToTopButton.style.display = 'none';
        backToTopButton.style.transition = 'opacity 0.3s, visibility 0.3s';
        
        window.addEventListener('scroll', function() {
            if (window.pageYOffset > 300) {
                backToTopButton.style.display = 'block';
                backToTopButton.style.opacity = '1';
                backToTopButton.style.visibility = 'visible';
            } else {
                backToTopButton.style.opacity = '0';
                backToTopButton.style.visibility = 'hidden';
            }
        });
        
        backToTopButton.addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    });
</script>

<style>
    /* Custom footer styles */
    .footer {
        position: relative;
    }
    
    .hover-primary:hover {
        color: var(--bs-primary) !important;
        transform: translateY(-2px);
        transition: all 0.3s ease;
    }
    
    .hover-white:hover {
        color: white !important;
        transition: color 0.3s ease;
    }
    
    #btn-back-to-top {
        position: fixed;
        bottom: 20px;
        right: 20px;
        z-index: 99;
        width: 50px;
        height: 50px;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    
    .social-icons a {
        transition: all 0.3s ease;
    }
    
    .social-icons a:hover {
        transform: translateY(-3px);
    }
    
    .nav-link {
        transition: color 0.2s ease;
    }
</style>
</body>
</html>