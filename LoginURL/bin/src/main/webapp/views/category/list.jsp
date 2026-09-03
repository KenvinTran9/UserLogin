<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Mục - LoginURL</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-brand">📋 LoginURL App</div>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/home" class="nav-link">🏠 Trang Chủ</a>
            <a href="${pageContext.request.contextPath}/category" class="nav-link active">📂 Danh Mục</a>
            <span class="nav-user">👤 ${sessionScope.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="nav-link nav-logout">🚪 Đăng Xuất</a>
        </div>
    </nav>

    <div class="container">
        <div class="page-header">
            <h2>📂 Quản Lý Danh Mục</h2>
            <a href="${pageContext.request.contextPath}/category?action=add" class="btn btn-primary">
                ➕ Thêm Danh Mục
            </a>
        </div>

        <c:if test="${not empty message}">
            <div class="alert alert-success">✅ ${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">⚠️ ${error}</div>
        </c:if>

        <div class="table-wrapper">
            <table class="data-table">
                <thead>
                    <tr>
                        <th style="width: 50px;">#</th>
                        <th>Ảnh</th>
                        <th>Tên Danh Mục</th>
                        <th>Mô Tả</th>
                        <th>File Đính Kèm</th>
                        <th style="width: 180px;">Hành Động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty categories}">
                            <tr>
                                <td colspan="6" class="empty-message">
                                    Chưa có danh mục nào. Hãy thêm mới!
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="cat" items="${categories}" varStatus="status">
                                <tr>
                                    <td>${status.index + 1}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty cat.imagePath}">
                                                <img src="${pageContext.request.contextPath}/${cat.imagePath}"
                                                     alt="${cat.name}" class="table-img">
                                            </c:when>
                                            <c:otherwise>
                                                <span class="no-image">📷</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><strong>${cat.name}</strong></td>
                                    <td>${cat.description}</td>
                                    <td>
                                        <c:if test="${not empty cat.filePath}">
                                            <a href="${pageContext.request.contextPath}/${cat.filePath}"
                                               class="file-link" download="${cat.fileName}">
                                                📎 ${cat.fileName}
                                            </a>
                                        </c:if>
                                        <c:if test="${empty cat.filePath}">
                                            <span style="color: #999;">—</span>
                                        </c:if>
                                    </td>
                                    <td class="action-cell">
                                        <a href="${pageContext.request.contextPath}/category?action=edit&id=${cat.id}"
                                           class="btn btn-sm btn-edit">✏️ Sửa</a>
                                        <a href="${pageContext.request.contextPath}/category?action=delete&id=${cat.id}"
                                           class="btn btn-sm btn-delete"
                                           onclick="return confirm('Bạn có chắc muốn xóa danh mục này?')">🗑️ Xóa</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
