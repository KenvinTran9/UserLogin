<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Danh Mục - LoginURL</title>
</head>
<body>
    <div class="container-fluid p-0">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="fw-bold mb-0"><i class="bi bi-folder-fill me-2 text-primary"></i>Quản Lý Danh Mục</h4>
            <a href="${pageContext.request.contextPath}/category?action=add" class="btn btn-primary">
                <i class="bi bi-plus-lg me-1"></i>Thêm Danh Mục
            </a>
        </div>

        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th style="width: 50px;">#</th>
                                <th style="width: 80px;">Ảnh</th>
                                <th>Tên Danh Mục</th>
                                <th>Mô Tả</th>
                                <th>File Đính Kèm</th>
                                <th style="width: 180px;" class="text-center">Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty categories}">
                                    <tr>
                                        <td colspan="6" class="text-center text-muted py-5">
                                            <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                            Chưa có danh mục nào. Hãy thêm mới!
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="cat" items="${categories}" varStatus="status">
                                        <tr>
                                            <td class="fw-semibold">${status.index + 1}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty cat.imagePath}">
                                                        <img src="${pageContext.request.contextPath}/${cat.imagePath}"
                                                             alt="${cat.name}" class="rounded-3 border"
                                                             style="width: 55px; height: 55px; object-fit: cover;">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="rounded-3 bg-light border d-flex align-items-center justify-content-center"
                                                             style="width: 55px; height: 55px;">
                                                            <i class="bi bi-image text-muted fs-4"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="fw-semibold">${cat.name}</td>
                                            <td class="text-muted">${cat.description}</td>
                                            <td>
                                                <c:if test="${not empty cat.filePath}">
                                                    <a href="${pageContext.request.contextPath}/${cat.filePath}"
                                                       class="text-primary text-decoration-none" download="${cat.fileName}">
                                                        <i class="bi bi-paperclip"></i> ${cat.fileName}
                                                    </a>
                                                </c:if>
                                                <c:if test="${empty cat.filePath}">
                                                    <span class="text-muted">—</span>
                                                </c:if>
                                            </td>
                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/category?action=edit&id=${cat.id}"
                                                   class="btn btn-sm btn-outline-primary me-1" title="Sửa">
                                                    <i class="bi bi-pencil"></i> Sửa
                                                </a>
                                                <a href="${pageContext.request.contextPath}/category?action=delete&id=${cat.id}"
                                                   class="btn btn-sm btn-outline-danger"
                                                   onclick="return confirm('Bạn có chắc muốn xóa danh mục này?')" title="Xóa">
                                                    <i class="bi bi-trash"></i> Xóa
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
