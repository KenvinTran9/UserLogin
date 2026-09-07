<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Trang Chủ - LoginURL</title>
</head>
<body>
    <div class="container-fluid p-0">
        <div class="row g-0">
            <div class="col-12">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                    <div class="card-header bg-gradient-primary text-white py-4 px-4">
                        <h2 class="mb-1"><i class="bi bi-hand-wave me-2"></i>Chào mừng, ${sessionScope.fullName}!</h2>
                        <p class="mb-0 opacity-75">Bạn đã đăng nhập thành công vào hệ thống.</p>
                    </div>
                    <div class="card-body p-4">
                        <div class="row g-3 mb-4">
                            <div class="col-md-4">
                                <div class="info-card p-3 rounded-3">
                                    <div class="text-muted small text-uppercase fw-bold mb-1">
                                        <i class="bi bi-person me-1"></i>Tên đăng nhập
                                    </div>
                                    <div class="fw-semibold fs-6">${sessionScope.username}</div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="info-card p-3 rounded-3">
                                    <div class="text-muted small text-uppercase fw-bold mb-1">
                                        <i class="bi bi-person-badge me-1"></i>Họ tên
                                    </div>
                                    <div class="fw-semibold fs-6">${sessionScope.fullName}</div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="info-card p-3 rounded-3">
                                    <div class="text-muted small text-uppercase fw-bold mb-1">
                                        <i class="bi bi-key me-1"></i>Session ID
                                    </div>
                                    <div class="fw-semibold small text-primary font-monospace" style="word-break: break-all;">${pageContext.session.id}</div>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex gap-3 justify-content-center flex-wrap">
                            <a href="${pageContext.request.contextPath}/category" class="btn btn-primary btn-lg">
                                <i class="bi bi-folder-fill me-2"></i>Quản Lý Danh Mục
                            </a>
                            <a href="${pageContext.request.contextPath}/profile" class="btn btn-outline-secondary btn-lg">
                                <i class="bi bi-person-fill me-2"></i>Cập Nhật Profile
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
