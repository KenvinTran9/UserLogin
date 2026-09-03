<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - LoginURL</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="login-page">
    <div class="login-container">
        <div class="login-card">
            <div class="login-header">
                <h1>🔐 Đăng Nhập</h1>
                <p>Vui lòng nhập thông tin đăng nhập</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    ⚠️ ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="POST" class="login-form">
                <div class="form-group">
                    <label for="username">Tên đăng nhập</label>
                    <input type="text" id="username" name="username"
                           value="${not empty rememberedUser ? rememberedUser : username}"
                           placeholder="Nhập tên đăng nhập" required autofocus>
                </div>

                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <input type="password" id="password" name="password"
                           placeholder="Nhập mật khẩu" required>
                </div>

                <div class="form-group checkbox-group">
                    <label class="checkbox-label">
                        <input type="checkbox" name="remember"
                               ${not empty rememberedUser ? 'checked' : ''}>
                        <span>Ghi nhớ đăng nhập</span>
                    </label>
                </div>

                <button type="submit" class="btn btn-primary btn-block">
                    Đăng Nhập
                </button>
            </form>

            <div class="login-footer">
                <p>Tài khoản mặc định: <strong>admin</strong> / <strong>admin123</strong></p>
            </div>
        </div>
    </div>
</body>
</html>
