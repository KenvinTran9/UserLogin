<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Trang Chủ - LoginURL</title>
</head>
<body>
    <div class="dashboard-container">
        <div class="welcome-card">
            <h2>Chào mừng, ${sessionScope.fullName}! 👋</h2>
            <p>Bạn đã đăng nhập thành công vào hệ thống.</p>

            <div class="info-grid">
                <div class="info-item">
                    <span class="info-label">Tên đăng nhập</span>
                    <span class="info-value">${sessionScope.username}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Họ tên</span>
                    <span class="info-value">${sessionScope.fullName}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Session ID</span>
                    <span class="info-value session-id">${pageContext.session.id}</span>
                </div>
            </div>

            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/category" class="btn btn-primary">
                    📂 Quản Lý Danh Mục
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="btn btn-secondary">
                    👤 Cập Nhật Profile
                </a>
            </div>
        </div>
    </div>
</body>
</html>
