<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${_decorator_title}</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    ${_decorator_head}
</head>
<body>
    <div class="layout-wrapper">
        <!-- Sidebar -->
        <aside class="sidebar" id="sidebarMenu">
            <div class="sidebar-header">
                <div class="sidebar-logo"><i class="bi bi-clipboard-data"></i></div>
                <h2 class="sidebar-title">LoginURL</h2>
            </div>

            <nav class="sidebar-nav">
                <a href="${pageContext.request.contextPath}/home" class="sidebar-link" id="nav-home">
                    <span class="sidebar-icon"><i class="bi bi-house-door-fill"></i></span>
                    <span class="sidebar-text">Trang Chủ</span>
                </a>
                <a href="${pageContext.request.contextPath}/category" class="sidebar-link" id="nav-category">
                    <span class="sidebar-icon"><i class="bi bi-folder-fill"></i></span>
                    <span class="sidebar-text">Danh Mục</span>
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="sidebar-link" id="nav-profile">
                    <span class="sidebar-icon"><i class="bi bi-person-fill"></i></span>
                    <span class="sidebar-text">Profile</span>
                </a>
            </nav>

            <div class="sidebar-footer">
                <div class="sidebar-user">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.imagePath}">
                            <img src="${pageContext.request.contextPath}/${sessionScope.user.imagePath}" alt="Avatar" class="sidebar-avatar">
                        </c:when>
                        <c:otherwise>
                            <div class="sidebar-avatar-default"><i class="bi bi-person-fill"></i></div>
                        </c:otherwise>
                    </c:choose>
                    <div class="sidebar-user-info">
                        <span class="sidebar-user-name">${sessionScope.fullName}</span>
                        <span class="sidebar-user-role">${sessionScope.username}</span>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="sidebar-link sidebar-logout">
                    <span class="sidebar-icon"><i class="bi bi-box-arrow-left"></i></span>
                    <span class="sidebar-text">Đăng Xuất</span>
                </a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="content-header">
                <button class="sidebar-toggle btn btn-link" onclick="toggleSidebar()" id="sidebar-toggle-btn">
                    <i class="bi bi-list fs-4"></i>
                </button>
                <h1 class="content-title">${_decorator_title}</h1>
                <div class="content-header-right">
                    <span class="header-greeting d-none d-md-inline">
                        <i class="bi bi-person-circle me-1"></i>Xin chào, ${sessionScope.fullName}
                    </span>
                </div>
            </div>
            <div class="content-body">
                ${_decorator_body}
            </div>
        </main>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleSidebar() {
            document.querySelector('.layout-wrapper').classList.toggle('sidebar-collapsed');
        }

        // Highlight active nav link
        (function() {
            var path = window.location.pathname;
            var links = document.querySelectorAll('.sidebar-link');
            links.forEach(function(link) {
                var href = link.getAttribute('href');
                if (href && path.indexOf(href) !== -1 && href !== '#') {
                    link.classList.add('active');
                }
            });
        })();
    </script>
</body>
</html>
