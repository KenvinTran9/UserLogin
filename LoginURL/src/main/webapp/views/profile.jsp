<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Profile - LoginURL</title>
</head>
<body>
    <div class="container-fluid" style="max-width: 750px; margin: 0 auto;">
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

        <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
            <div class="card-header bg-gradient-primary text-white text-center py-5">
                <div class="avatar-section">
                    <div class="avatar-wrapper mx-auto" style="width: 120px; height: 120px;" onclick="document.getElementById('image').click()">
                        <c:choose>
                            <c:when test="${not empty user.imagePath}">
                                <img src="${pageContext.request.contextPath}/${user.imagePath}"
                                     alt="Avatar" class="avatar-img" id="currentAvatar">
                            </c:when>
                            <c:otherwise>
                                <div class="avatar-placeholder" id="currentAvatar">
                                    <i class="bi bi-person-fill" style="font-size: 48px;"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div class="avatar-overlay">
                            <i class="bi bi-camera-fill"></i>
                            <span>Đổi ảnh</span>
                        </div>
                    </div>
                    <h3 class="mt-3 mb-1 fw-bold">${user.fullName}</h3>
                    <p class="mb-0 opacity-75">@${user.username}</p>
                </div>
            </div>

            <div class="card-body p-4">
                <form action="${pageContext.request.contextPath}/profile" method="POST"
                      enctype="multipart/form-data" class="needs-validation" novalidate id="profileForm">

                    <input type="file" id="image" name="image" accept="image/*" style="display: none;">
                    <c:if test="${not empty errors.image}">
                        <div class="alert alert-danger py-2"><i class="bi bi-exclamation-triangle me-1"></i>${errors.image}</div>
                    </c:if>
                    <div id="imagePreview" class="mb-3"></div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="fullName" class="form-label fw-semibold">Họ và Tên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control ${not empty errors.fullName ? 'is-invalid' : ''}"
                                   id="fullName" name="fullName"
                                   value="${user.fullName}" placeholder="Nhập họ và tên"
                                   required minlength="2" maxlength="100">
                            <c:if test="${not empty errors.fullName}">
                                <div class="invalid-feedback">${errors.fullName}</div>
                            </c:if>
                            <c:if test="${empty errors.fullName}">
                                <div class="invalid-feedback">Họ và tên phải từ 2 đến 100 ký tự</div>
                            </c:if>
                        </div>

                        <div class="col-md-6">
                            <label for="phone" class="form-label fw-semibold">Số điện thoại</label>
                            <input type="text" class="form-control ${not empty errors.phone ? 'is-invalid' : ''}"
                                   id="phone" name="phone"
                                   value="${user.phone}" placeholder="Nhập số điện thoại"
                                   pattern="[0-9]{10,11}">
                            <c:if test="${not empty errors.phone}">
                                <div class="invalid-feedback">${errors.phone}</div>
                            </c:if>
                            <c:if test="${empty errors.phone}">
                                <div class="invalid-feedback">Số điện thoại phải gồm 10-11 chữ số</div>
                            </c:if>
                        </div>

                        <div class="col-md-6">
                            <label for="emailDisplay" class="form-label fw-semibold">Email</label>
                            <input type="email" class="form-control" id="emailDisplay" value="${user.email}" disabled>
                            <small class="text-muted">Email không thể thay đổi</small>
                        </div>

                        <div class="col-md-6">
                            <label for="usernameDisplay" class="form-label fw-semibold">Tên đăng nhập</label>
                            <input type="text" class="form-control" id="usernameDisplay" value="${user.username}" disabled>
                            <small class="text-muted">Username không thể thay đổi</small>
                        </div>
                    </div>

                    <div class="text-center mt-4 pt-3 border-top">
                        <button type="submit" class="btn btn-primary btn-lg px-5">
                            <i class="bi bi-save me-2"></i>Lưu Thay Đổi
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Image preview and avatar update
        document.getElementById('image').addEventListener('change', function(e) {
            var preview = document.getElementById('imagePreview');
            var currentAvatar = document.getElementById('currentAvatar');
            preview.innerHTML = '';
            if (this.files && this.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    if (currentAvatar.tagName === 'IMG') {
                        currentAvatar.src = e.target.result;
                    } else {
                        var img = document.createElement('img');
                        img.src = e.target.result;
                        img.alt = 'Avatar';
                        img.className = 'avatar-img';
                        img.id = 'currentAvatar';
                        currentAvatar.parentNode.replaceChild(img, currentAvatar);
                    }
                    var info = document.createElement('div');
                    info.className = 'alert alert-info py-2';
                    info.innerHTML = '<i class="bi bi-image me-1"></i> Ảnh mới đã chọn: ' + document.getElementById('image').files[0].name;
                    preview.appendChild(info);
                };
                reader.readAsDataURL(this.files[0]);
            }
        });

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
