class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "https://arrayfire.com"
  url "https://ghfast.top/https://github.com/arrayfire/arrayfire/releases/download/v3.10.0/arrayfire-full-3.10.0.tar.bz2"
  sha256 "74e14b92a3e5a3ed6b79b000c7625b6223400836ec2ba724c3b356282ea741b3"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "79797fbff6b0a68fae6cbda4e13c224d596861b3df5b9889e78be7e4a54ee90f"
    sha256 cellar: :any,                 arm64_sequoia: "8150e85b70b32027bc8c87a55b13b546b7dc6405458306112606a4c7965a45ae"
    sha256 cellar: :any,                 arm64_sonoma:  "66dc68b838926eb3d689a0e9a9fcb7deeaf9b90f4f809f419ef0ba8a7f031a44"
    sha256 cellar: :any,                 sonoma:        "7b0f4d0fde20847ba10c28ed6be785bd03ca904e0b916d27faf21a11e67e92c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68cc847cd44e1e1b1243f7dfbef1e1993c1d680f5e991409b23d94d3ef2114a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2893d19f51840edf453d8f85da08c1864cc8cb539e00d12fb8e78f1808a83295"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "clblast"
  depends_on "fftw"
  depends_on "fmt"
  depends_on "openblas"
  depends_on "spdlog"

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  fails_with :gcc do
    cause <<~CAUSE
      Building with GCC and CMake CXX_EXTENSIONS disabled causes OpenCL headers
      to not expose cl_image_desc.mem_object which is needed by Boost.Compute.
    CAUSE
  end

  # fmt 11 compatibility
  # https://github.com/arrayfire/arrayfire/issues/3596
  patch :DATA

  def install
    # FreeImage has multiple CVEs (https://github.com/arrayfire/arrayfire/issues/3547) and
    # has been dropped by distros like Arch Linux (https://archlinux.org/todo/drop-freeimage/).
    odie "FreeImage should not be a dependency!" if deps.map(&:name).include?("freeimage")

    # Fix for: `ArrayFire couldn't locate any backends.`
    rpaths = [
      rpath(source: lib, target: Formula["fftw"].opt_lib),
      rpath(source: lib, target: Formula["openblas"].opt_lib),
      rpath(source: lib, target: HOMEBREW_PREFIX/"lib"),
    ]

    # Our compiler shims strip `-Werror`, which breaks upstream detection of linker features.
    # https://github.com/arrayfire/arrayfire/blob/715e21fcd6e989793d01c5781908f221720e7d48/src/backend/opencl/CMakeLists.txt#L598
    inreplace "src/backend/opencl/CMakeLists.txt", "if(group_flags)", "if(FALSE)" if OS.mac?

    system "cmake", "-S", ".", "-B", "build",
                    "-DAF_BUILD_CUDA=OFF",
                    "-DAF_COMPUTE_LIBRARY=FFTW/LAPACK/BLAS",
                    "-DAF_WITH_EXTERNAL_PACKAGES_ONLY=ON",
                    "-DCMAKE_CXX_STANDARD=14",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    ENV.method(DevelopmentTools.default_compiler).call if OS.linux?
    cp pkgshare/"examples/helloworld/helloworld.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laf", "-lafcpu", "-o", "test"
    # OpenCL does not work in CI.
    return if Hardware::CPU.arm? && OS.mac? && MacOS.version >= :monterey && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "ArrayFire v#{version}", shell_output("./test")
  end
end

__END__
diff --git a/src/backend/common/jit/NodeIO.hpp b/src/backend/common/jit/NodeIO.hpp
index ac149d9..edffdfa 100644
--- a/src/backend/common/jit/NodeIO.hpp
+++ b/src/backend/common/jit/NodeIO.hpp
@@ -16,7 +16,7 @@
 template<>
 struct fmt::formatter<af::dtype> : fmt::formatter<char> {
     template<typename FormatContext>
-    auto format(const af::dtype& p, FormatContext& ctx) -> decltype(ctx.out()) {
+    auto format(const af::dtype& p, FormatContext& ctx) const -> decltype(ctx.out()) {
         format_to(ctx.out(), "{}", arrayfire::common::getName(p));
         return ctx.out();
     }
@@ -58,7 +58,7 @@ struct fmt::formatter<arrayfire::common::Node> {
     // Formats the point p using the parsed format specification (presentation)
     // stored in this formatter.
     template<typename FormatContext>
-    auto format(const arrayfire::common::Node& node, FormatContext& ctx)
+    auto format(const arrayfire::common::Node& node, FormatContext& ctx) const
         -> decltype(ctx.out()) {
         // ctx.out() is an output iterator to write to.

diff --git a/src/backend/common/ArrayFireTypesIO.hpp b/src/backend/common/ArrayFireTypesIO.hpp
index e7a2e08..5da74a9 100644
--- a/src/backend/common/ArrayFireTypesIO.hpp
+++ b/src/backend/common/ArrayFireTypesIO.hpp
@@ -21,7 +21,7 @@ struct fmt::formatter<af_seq> {
     }

     template<typename FormatContext>
-    auto format(const af_seq& p, FormatContext& ctx) -> decltype(ctx.out()) {
+    auto format(const af_seq& p, FormatContext& ctx) const -> decltype(ctx.out()) {
         // ctx.out() is an output iterator to write to.
         if (p.begin == af_span.begin && p.end == af_span.end &&
             p.step == af_span.step) {
@@ -73,18 +73,16 @@ struct fmt::formatter<arrayfire::common::Version> {
     }

     template<typename FormatContext>
-    auto format(const arrayfire::common::Version& ver, FormatContext& ctx)
+    auto format(const arrayfire::common::Version& ver, FormatContext& ctx) const
         -> decltype(ctx.out()) {
         if (ver.major() == -1) return format_to(ctx.out(), "N/A");
-        if (ver.minor() == -1) show_minor = false;
-        if (ver.patch() == -1) show_patch = false;
-        if (show_major && !show_minor && !show_patch) {
+        if (show_major && (!show_minor || ver.minor() == -1) && (!show_patch || ver.patch() == -1)) {
             return format_to(ctx.out(), "{}", ver.major());
         }
-        if (show_major && show_minor && !show_patch) {
+        if (show_major && (show_minor && ver.minor() != -1) && (!show_patch || ver.patch() == -1)) {
             return format_to(ctx.out(), "{}.{}", ver.major(), ver.minor());
         }
-        if (show_major && show_minor && show_patch) {
+        if (show_major && (show_minor && ver.minor() != -1) && (show_patch && ver.patch() != -1)) {
             return format_to(ctx.out(), "{}.{}.{}", ver.major(), ver.minor(),
                              ver.patch());
         }
diff --git a/src/backend/common/debug.hpp b/src/backend/common/debug.hpp
index 54e74a2..07fa589 100644
--- a/src/backend/common/debug.hpp
+++ b/src/backend/common/debug.hpp
@@ -12,6 +12,7 @@
 #include <boost/stacktrace.hpp>
 #include <common/ArrayFireTypesIO.hpp>
 #include <common/jit/NodeIO.hpp>
+#include <fmt/ranges.h>
 #include <spdlog/fmt/bundled/format.h>
 #include <iostream>

diff --git a/src/backend/opencl/compile_module.cpp b/src/backend/opencl/compile_module.cpp
index 89d382c..2c979fd 100644
--- a/src/backend/opencl/compile_module.cpp
+++ b/src/backend/opencl/compile_module.cpp
@@ -22,6 +22,8 @@
 #include <platform.hpp>
 #include <traits.hpp>

+#include <fmt/ranges.h>
+
 #include <algorithm>
 #include <cctype>
 #include <cstdio>