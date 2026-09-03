<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Lỗi Đăng Nhập - LoginURL</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body class="login-page">
            <div class="login-container">
                <div class="login-card">
                    <div class="login-header">
                        <h1>❌ Đăng Nhập Thất Bại</h1>
                    </div>

                    <div class="alert alert-error">
                        ⚠️ ${errorMessage}
                    </div>

                    <p style="text-align: center; color: #888; margin-bottom: 24px;">
                        Vui lòng kiểm tra lại tên đăng nhập và mật khẩu.
                    </p>

                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-block">
                        ↩️ Quay Lại Đăng Nhập
                    </a>
                </div>
            </div>
        </body>

        </html>