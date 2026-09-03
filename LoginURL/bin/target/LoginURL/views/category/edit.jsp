<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa Danh Mục - LoginURL</title>
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
        <div class="form-card">
            <h2>✏️ Sửa Danh Mục</h2>

            <c:if test="${not empty error}">
                <div class="alert alert-error">⚠️ ${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/category" method="POST"
                  enctype="multipart/form-data" class="crud-form">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${category.id}">

                <div class="form-group">
                    <label for="name">Tên danh mục <span class="required">*</span></label>
                    <input type="text" id="name" name="name"
                           value="${category.name}"
                           placeholder="Nhập tên danh mục" required autofocus>
                </div>

                <div class="form-group">
                    <label for="description">Mô tả</label>
                    <textarea id="description" name="description" rows="4"
                              placeholder="Nhập mô tả danh mục">${category.description}</textarea>
                </div>

                <div class="form-group">
                    <label for="image">🖼️ Ảnh danh mục</label>
                    <c:if test="${not empty category.imagePath}">
                        <div class="current-file">
                            <p>Ảnh hiện tại:</p>
                            <img src="${pageContext.request.contextPath}/${category.imagePath}"
                                 alt="${category.name}" class="current-img">
                        </div>
                    </c:if>
                    <input type="file" id="image" name="image" accept="image/*" class="file-input">
                    <small class="form-hint">Chọn ảnh mới để thay thế (bỏ trống = giữ ảnh cũ)</small>
                    <div id="imagePreview" class="image-preview"></div>
                </div>

                <div class="form-group">
                    <label for="file">📎 File đính kèm</label>
                    <c:if test="${not empty category.filePath}">
                        <div class="current-file">
                            <p>File hiện tại:
                                <a href="${pageContext.request.contextPath}/${category.filePath}"
                                   download="${category.fileName}" class="file-link">
                                    📎 ${category.fileName}
                                </a>
                            </p>
                        </div>
                    </c:if>
                    <input type="file" id="file" name="file" class="file-input">
                    <small class="form-hint">Chọn file mới để thay thế (bỏ trống = giữ file cũ)</small>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">💾 Cập Nhật</button>
                    <a href="${pageContext.request.contextPath}/category" class="btn btn-secondary">↩️ Quay Lại</a>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.getElementById('image').addEventListener('change', function(e) {
            var preview = document.getElementById('imagePreview');
            preview.innerHTML = '';
            if (this.files && this.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    var img = document.createElement('img');
                    img.src = e.target.result;
                    img.style.maxWidth = '200px';
                    img.style.maxHeight = '200px';
                    img.style.borderRadius = '8px';
                    img.style.marginTop = '10px';
                    preview.appendChild(img);
                };
                reader.readAsDataURL(this.files[0]);
            }
        });
    </script>
</body>
</html>
