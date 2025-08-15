class ProtobufAT29 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://ghfast.top/https://github.com/protocolbuffers/protobuf/releases/download/v29.5/protobuf-29.5.tar.gz"
  sha256 "a191d2afdd75997ba59f62019425016703daed356a9d92f7425f4741439ae544"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(29(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1925b35d8251d8ee533e2bf378191ccfaa0eae898b8ebb557bf31a44380e3527"
    sha256 cellar: :any,                 arm64_sonoma:  "b2ddb8fc16385c7c8e0f90ff9dda5ad9f0cff42718350bdb975cec49175d59b6"
    sha256 cellar: :any,                 arm64_ventura: "0290d19843407a272ca8474bf6e7c00ababa9b374678611f3059e54297d84b5f"
    sha256 cellar: :any,                 sonoma:        "7c043b24312d634fa1468bdf5c369ec1c6f69cdc9391844a56cf26ad43183c31"
    sha256 cellar: :any,                 ventura:       "7d34af0f93bba3fc9b4d42e9e6ca16a91f57146184f6c01a861473b0c0af6257"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96018433e703af65c0fa8330ccede6ad5d055abb748ed4c796e9062cd2fefbd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60f8f1a063806ecd090ac0ee5512c827a97760d67c0d09b6b4f553a552215dd5"
  end

  keg_only :versioned_formula

  # Support for protoc 29.x (protobuf C++ 5.29.x) will end on 2026-03-31
  # Ref: https://protobuf.dev/support/version-support/#cpp
  deprecate! date: "2026-03-31", because: :versioned_formula

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "abseil"
  uses_from_macos "zlib"

  # Backport to expose java-related symbols
  patch do
    url "https://github.com/protocolbuffers/protobuf/commit/9dc5aaa1e99f16065e25be4b9aab0a19bfb65ea2.patch?full_index=1"
    sha256 "edc1befbc3d7f7eded6b7516b3b21e1aa339aee70e17c96ab337f22e60e154d7"
  end

  # Backport patch for compatibility with new Abseil.
  patch do
    url "https://github.com/protocolbuffers/protobuf/commit/d801cbd86818b587e0ebba2de13614a3ee83d369.patch?full_index=1"
    sha256 "ebab85f5b2c817b4adcd0bc66a7377a0aa4b9ecf667f1893f918c318369d3ef0"
  end

  # Backport of (for compatibility with new Abseil):
  # https://github.com/protocolbuffers/protobuf/commit/0ea5ccd61c69ff5000631781c6c9a3a50241392c.patch?full_index=1
  patch :DATA

  def install
    # Keep `CMAKE_CXX_STANDARD` in sync with the same variable in `abseil.rb`.
    abseil_cxx_standard = 17
    cmake_args = %W[
      -DCMAKE_CXX_STANDARD=#{abseil_cxx_standard}
      -DBUILD_SHARED_LIBS=ON
      -Dprotobuf_BUILD_LIBPROTOC=ON
      -Dprotobuf_BUILD_SHARED_LIBS=ON
      -Dprotobuf_INSTALL_EXAMPLES=ON
      -Dprotobuf_BUILD_TESTS=#{OS.mac? ? "ON" : "OFF"}
      -Dprotobuf_USE_EXTERNAL_GTEST=ON
      -Dprotobuf_ABSL_PROVIDER=package
      -Dprotobuf_JSONCPP_PROVIDER=package
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build", "--verbose"
    system "cmake", "--install", "build"

    (share/"vim/vimfiles/syntax").install "editors/proto.vim"
    elisp.install "editors/protobuf-mode.el"
  end

  test do
    (testpath/"test.proto").write <<~PROTO
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    PROTO
    system bin/"protoc", "test.proto", "--cpp_out=."
  end
end

__END__
diff --git i/src/google/protobuf/arena.h w/src/google/protobuf/arena.h
index 545fd51..55b1ec8 100644
--- i/src/google/protobuf/arena.h
+++ w/src/google/protobuf/arena.h
@@ -32,7 +32,6 @@ using type_info = ::type_info;
 #include "absl/base/optimization.h"
 #include "absl/base/prefetch.h"
 #include "absl/log/absl_check.h"
-#include "absl/utility/internal/if_constexpr.h"
 #include "google/protobuf/arena_align.h"
 #include "google/protobuf/arena_allocation_policy.h"
 #include "google/protobuf/port.h"
@@ -214,41 +213,31 @@ class PROTOBUF_EXPORT PROTOBUF_ALIGNAS(8) Arena final {
   // otherwise, returns a heap-allocated object.
   template <typename T, typename... Args>
   PROTOBUF_NDEBUG_INLINE static T* Create(Arena* arena, Args&&... args) {
-    return absl::utility_internal::IfConstexprElse<
-        is_arena_constructable<T>::value>(
-        // Arena-constructable
-        [arena](auto&&... args) {
-          using Type = std::remove_const_t<T>;
-#ifdef __cpp_if_constexpr
-          // DefaultConstruct/CopyConstruct are optimized for messages, which
-          // are both arena constructible and destructor skippable and they
-          // assume much. Don't use these functions unless the invariants
-          // hold.
-          if constexpr (is_destructor_skippable<T>::value) {
-            constexpr auto construct_type = GetConstructType<T, Args&&...>();
-            // We delegate to DefaultConstruct/CopyConstruct where appropriate
-            // because protobuf generated classes have external templates for
-            // these functions for code size reasons. When `if constexpr` is not
-            // available always use the fallback.
-            if constexpr (construct_type == ConstructType::kDefault) {
-              return static_cast<Type*>(DefaultConstruct<Type>(arena));
-            } else if constexpr (construct_type == ConstructType::kCopy) {
-              return static_cast<Type*>(CopyConstruct<Type>(arena, &args...));
-            }
-          }
-#endif
-          return CreateArenaCompatible<Type>(arena,
-                                             std::forward<Args>(args)...);
-        },
-        // Non arena-constructable
-        [arena](auto&&... args) {
-          if (PROTOBUF_PREDICT_FALSE(arena == nullptr)) {
-            return new T(std::forward<Args>(args)...);
-          }
-          return new (arena->AllocateInternal<T>())
-              T(std::forward<Args>(args)...);
-        },
-        std::forward<Args>(args)...);
+    if constexpr (is_arena_constructable<T>::value) {
+      using Type = std::remove_const_t<T>;
+      // DefaultConstruct/CopyConstruct are optimized for messages, which
+      // are both arena constructible and destructor skippable and they
+      // assume much. Don't use these functions unless the invariants
+      // hold.
+      if constexpr (is_destructor_skippable<T>::value) {
+        constexpr auto construct_type = GetConstructType<T, Args&&...>();
+        // We delegate to DefaultConstruct/CopyConstruct where appropriate
+        // because protobuf generated classes have external templates for
+        // these functions for code size reasons. When `if constexpr` is not
+        // available always use the fallback.
+        if constexpr (construct_type == ConstructType::kDefault) {
+          return static_cast<Type*>(DefaultConstruct<Type>(arena));
+        } else if constexpr (construct_type == ConstructType::kCopy) {
+          return static_cast<Type*>(CopyConstruct<Type>(arena, &args...));
+        }
+      }
+      return CreateArenaCompatible<Type>(arena, std::forward<Args>(args)...);
+    } else {
+      if (ABSL_PREDICT_FALSE(arena == nullptr)) {
+        return new T(std::forward<Args>(args)...);
+      }
+      return new (arena->AllocateInternal<T>()) T(std::forward<Args>(args)...);
+    }
   }
 
   // API to delete any objects not on an arena.  This can be used to safely