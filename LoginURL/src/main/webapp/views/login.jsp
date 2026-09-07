<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - LoginURL</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="login-page">
    <div class="login-container">
        <div class="login-card">
            <div class="login-header">
                <div class="login-icon"><i class="bi bi-shield-lock-fill"></i></div>
                <h1>Đăng Nhập</h1>
                <p>Vui lòng nhập thông tin đăng nhập</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger d-flex align-items-center" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    <div>${error}</div>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="POST" class="login-form needs-validation" novalidate id="loginForm">
                <div class="mb-3">
                    <label for="username" class="form-label fw-semibold">Tên đăng nhập</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-person"></i></span>
                        <input type="text" class="form-control ${not empty errors.username ? 'is-invalid' : ''}"
                               id="username" name="username"
                               value="${not empty rememberedUser ? rememberedUser : username}"
                               placeholder="Nhập tên đăng nhập" required minlength="3" maxlength="50" autofocus>
                        <c:if test="${not empty errors.username}">
                            <div class="invalid-feedback">${errors.username}</div>
                        </c:if>
                        <c:if test="${empty errors.username}">
                            <div class="invalid-feedback">Vui lòng nhập tên đăng nhập (3-50 ký tự)</div>
                        </c:if>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label fw-semibold">Mật khẩu</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-lock"></i></span>
                        <input type="password" class="form-control ${not empty errors.password ? 'is-invalid' : ''}"
                               id="password" name="password"
                               placeholder="Nhập mật khẩu" required minlength="3" maxlength="50">
                        <c:if test="${not empty errors.password}">
                            <div class="invalid-feedback">${errors.password}</div>
                        </c:if>
                        <c:if test="${empty errors.password}">
                            <div class="invalid-feedback">Vui lòng nhập mật khẩu (3-50 ký tự)</div>
                        </c:if>
                    </div>
                </div>

                <div class="mb-4">
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="remember" name="remember"
                               ${not empty rememberedUser ? 'checked' : ''}>
                        <label class="form-check-label" for="remember">Ghi nhớ đăng nhập</label>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-lg w-100">
                    <i class="bi bi-box-arrow-in-right me-2"></i>Đăng Nhập
                </button>
            </form>

            <div class="login-footer">
                <p>Tài khoản mặc định: <strong>admin</strong> / <strong>admin123</strong></p>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Bootstrap 5 form validation
        (function() {
            'use strict';
            var forms = document.querySelectorAll('.needs-validation');
            Array.prototype.slice.call(forms).forEach(function(form) {
                form.addEventListener('submit', function(event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
    </script>
</body>
</html>
