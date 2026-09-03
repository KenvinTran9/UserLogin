<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ - LoginURL</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-brand">📋 LoginURL App</div>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/home" class="nav-link active">🏠 Trang Chủ</a>
            <a href="${pageContext.request.contextPath}/category" class="nav-link">📂 Danh Mục</a>
            <span class="nav-user">👤 ${sessionScope.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="nav-link nav-logout">🚪 Đăng Xuất</a>
        </div>
    </nav>

    <div class="container">
        <div class="welcome-card">
            <h2>Chào mừng, ${sessionScope.fullName}!</h2>
            <p>Bạn đã đăng nhập thành công vào hệ thống.</p>

            <div class="info-grid">
                <div class="info-item">
                    <span class="info-label">Tên đăng nhập:</span>
                    <span class="info-value">${sessionScope.username}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Họ tên:</span>
                    <span class="info-value">${sessionScope.fullName}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Session ID:</span>
                    <span class="info-value session-id">${pageContext.session.id}</span>
                </div>
            </div>

            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/category" class="btn btn-primary">
                    📂 Quản Lý Danh Mục
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary">
                    🚪 Đăng Xuất
                </a>
            </div>
        </div>
    </div>
</body>
</html>
