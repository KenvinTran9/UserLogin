<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Sửa Danh Mục - LoginURL</title>
</head>
<body>
    <div class="container-fluid" style="max-width: 650px; margin: 0 auto;">
        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-header bg-white border-bottom py-3 px-4">
                <h5 class="mb-0 fw-bold"><i class="bi bi-pencil-square me-2 text-warning"></i>Sửa Danh Mục</h5>
            </div>
            <div class="card-body p-4">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger d-flex align-items-center" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/category" method="POST"
                      enctype="multipart/form-data" class="needs-validation" novalidate id="editCategoryForm">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="${category.id}">

                    <div class="mb-3">
                        <label for="name" class="form-label fw-semibold">Tên danh mục <span class="text-danger">*</span></label>
                        <input type="text" class="form-control ${not empty errors.name ? 'is-invalid' : ''}"
                               id="name" name="name" value="${category.name}"
                               placeholder="Nhập tên danh mục" required minlength="2" maxlength="100" autofocus>
                        <c:if test="${not empty errors.name}">
                            <div class="invalid-feedback">${errors.name}</div>
                        </c:if>
                        <c:if test="${empty errors.name}">
                            <div class="invalid-feedback">Tên danh mục phải từ 2 đến 100 ký tự</div>
                        </c:if>
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label fw-semibold">Mô tả</label>
                        <textarea class="form-control ${not empty errors.description ? 'is-invalid' : ''}"
                                  id="description" name="description" rows="4"
                                  placeholder="Nhập mô tả danh mục" maxlength="500">${category.description}</textarea>
                        <c:if test="${not empty errors.description}">
                            <div class="invalid-feedback">${errors.description}</div>
                        </c:if>
                        <div class="form-text"><span id="descCount">0</span>/500 ký tự</div>
                    </div>

                    <div class="mb-3">
                        <label for="image" class="form-label fw-semibold"><i class="bi bi-image me-1"></i>Ảnh danh mục</label>
                        <c:if test="${not empty category.imagePath}">
                            <div class="mb-2 p-2 bg-light rounded-3 border">
                                <small class="text-muted d-block mb-1">Ảnh hiện tại:</small>
                                <img src="${pageContext.request.contextPath}/${category.imagePath}"
                                     alt="${category.name}" class="rounded-3" style="max-width: 180px; max-height: 180px;">
                            </div>
                        </c:if>
                        <input type="file" class="form-control ${not empty errors.image ? 'is-invalid' : ''}"
                               id="image" name="image" accept="image/jpeg,image/png,image/gif">
                        <c:if test="${not empty errors.image}">
                            <div class="invalid-feedback">${errors.image}</div>
                        </c:if>
                        <small class="text-muted">Chọn ảnh mới để thay thế (bỏ trống = giữ ảnh cũ)</small>
                        <div id="imagePreview" class="mt-2"></div>
                    </div>

                    <div class="mb-3">
                        <label for="file" class="form-label fw-semibold"><i class="bi bi-paperclip me-1"></i>File đính kèm</label>
                        <c:if test="${not empty category.filePath}">
                            <div class="mb-2 p-2 bg-light rounded-3 border">
                                <small class="text-muted">File hiện tại:</small>
                                <a href="${pageContext.request.contextPath}/${category.filePath}"
                                   download="${category.fileName}" class="ms-1 text-primary">
                                    <i class="bi bi-paperclip"></i> ${category.fileName}
                                </a>
                            </div>
                        </c:if>
                        <input type="file" class="form-control ${not empty errors.file ? 'is-invalid' : ''}"
                               id="file" name="file">
                        <c:if test="${not empty errors.file}">
                            <div class="invalid-feedback">${errors.file}</div>
                        </c:if>
                        <small class="text-muted">Chọn file mới để thay thế (bỏ trống = giữ file cũ)</small>
                    </div>

                    <div class="d-flex gap-2 pt-3 border-top">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-save me-1"></i>Cập Nhật
                        </button>
                        <a href="${pageContext.request.contextPath}/category" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i>Quay Lại
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Image preview
        document.getElementById('image').addEventListener('change', function(e) {
            var preview = document.getElementById('imagePreview');
            preview.innerHTML = '';
            if (this.files && this.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    var img = document.createElement('img');
                    img.src = e.target.result;
                    img.className = 'rounded-3 border';
                    img.style.maxWidth = '200px';
                    img.style.maxHeight = '200px';
                    preview.appendChild(img);
                };
                reader.readAsDataURL(this.files[0]);
            }
        });

        // Description character count
        var descField = document.getElementById('description');
        var descCount = document.getElementById('descCount');
        descField.addEventListener('input', function() {
            descCount.textContent = this.value.length;
        });
        descCount.textContent = descField.value.length;

        // Bootstrap validation
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
