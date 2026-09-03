<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Profile - LoginURL</title>
</head>
<body>
    <div class="profile-container">
        <c:if test="${not empty message}">
            <div class="alert alert-success">✅ ${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">⚠️ ${error}</div>
        </c:if>

        <div class="profile-card">
            <div class="profile-header">
                <div class="avatar-section">
                    <div class="avatar-wrapper">
                        <c:choose>
                            <c:when test="${not empty user.imagePath}">
                                <img src="${pageContext.request.contextPath}/${user.imagePath}" 
                                     alt="Avatar" class="avatar-img" id="currentAvatar">
                            </c:when>
                            <c:otherwise>
                                <div class="avatar-placeholder" id="currentAvatar">👤</div>
                            </c:otherwise>
                        </c:choose>
                        <div class="avatar-overlay" onclick="document.getElementById('image').click()">
                            <span>📷</span>
                            <span>Đổi ảnh</span>
                        </div>
                    </div>
                    <h2 class="profile-name">${user.fullName}</h2>
                    <p class="profile-username">@${user.username}</p>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/profile" method="POST"
                  enctype="multipart/form-data" class="profile-form">

                <input type="file" id="image" name="image" accept="image/*" style="display: none;">
                <div id="imagePreview" class="image-preview-area"></div>

                <div class="form-grid">
                    <div class="form-group">
                        <label for="fullName">Họ và Tên</label>
                        <input type="text" id="fullName" name="fullName" 
                               value="${user.fullName}" placeholder="Nhập họ và tên" required>
                    </div>

                    <div class="form-group">
                        <label for="phone">Số điện thoại</label>
                        <input type="text" id="phone" name="phone" 
                               value="${user.phone}" placeholder="Nhập số điện thoại">
                    </div>

                    <div class="form-group">
                        <label for="emailDisplay">Email</label>
                        <input type="email" id="emailDisplay" value="${user.email}" 
                               disabled class="input-disabled">
                        <small class="form-hint">Email không thể thay đổi</small>
                    </div>

                    <div class="form-group">
                        <label for="usernameDisplay">Tên đăng nhập</label>
                        <input type="text" id="usernameDisplay" value="${user.username}" 
                               disabled class="input-disabled">
                        <small class="form-hint">Username không thể thay đổi</small>
                    </div>
                </div>

                <div class="form-actions profile-actions">
                    <button type="submit" class="btn btn-primary btn-lg">
                        💾 Lưu Thay Đổi
                    </button>
                </div>
            </form>
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
                    // Update the avatar preview
                    if (currentAvatar.tagName === 'IMG') {
                        currentAvatar.src = e.target.result;
                    } else {
                        // Replace placeholder with image
                        var img = document.createElement('img');
                        img.src = e.target.result;
                        img.alt = 'Avatar';
                        img.className = 'avatar-img';
                        img.id = 'currentAvatar';
                        currentAvatar.parentNode.replaceChild(img, currentAvatar);
                    }
                    // Show file name
                    var info = document.createElement('p');
                    info.className = 'preview-info';
                    info.textContent = '📷 Ảnh mới đã chọn: ' + document.getElementById('image').files[0].name;
                    preview.appendChild(info);
                };
                reader.readAsDataURL(this.files[0]);
            }
        });
    </script>
</body>
</html>
