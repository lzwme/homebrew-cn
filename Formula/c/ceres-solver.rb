class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  license "BSD-3-Clause"
  revision 3
  head "https://ceres-solver.googlesource.com/ceres-solver.git", branch: "master"

  stable do
    url "http://ceres-solver.org/ceres-solver-2.2.0.tar.gz"
    sha256 "48b2302a7986ece172898477c3bcd6deb8fb5cf19b3327bc49969aad4cede82d"

    # Backport support for eigen 5.0.0
    patch :DATA # https://github.com/ceres-solver/ceres-solver/commit/f0720aeb84ec7bb479fe3618b30fa54981baf8fd
    patch do
      url "https://github.com/ceres-solver/ceres-solver/commit/f9b7b6651b108136a16df44d91fb31735645f5a7.patch?full_index=1"
      sha256 "019006cc850b19b442e108118c599c98b18af8eb06ab37c22e6698c55d55a512"
    end
  end

  livecheck do
    url "http://ceres-solver.org/installation.html"
    regex(/href=.*?ceres-solver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "81b100c1ef3f92810a9b4f2b9a602b7a1e6b6d7e11a88a677a2886f53fcaccb6"
    sha256 cellar: :any,                 arm64_sequoia: "dae580fccf96c376fc90bca15973a3375dd56dfe6a3760a19041ec52fc6c621e"
    sha256 cellar: :any,                 arm64_sonoma:  "66b7cfa4fabfc643db7d86944657198286a8665f2c00302071091680b6fa03b3"
    sha256 cellar: :any,                 sonoma:        "d997d14192319044b9a573c2d550779dd24c90c574f2c285ca5d705de509f648"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dc978b76da56deeec522b9c78fee5348c3d34849704c218cef09c63604aea85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e9385fbe9eeb9f92b0a190ad029bbf9aa916d05c8784afcce5f86b307848ac8"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "eigen"
  depends_on "gflags"
  depends_on "glog"
  depends_on "metis"
  depends_on "openblas"
  depends_on "suite-sparse"
  depends_on "tbb"

  def install
    system "cmake", "-S", ".", "-B", "homebrew-build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_EXAMPLES=OFF",
                    "-DLIB_SUFFIX=''",
                    *std_cmake_args
    system "cmake", "--build", "homebrew-build"
    system "cmake", "--install", "homebrew-build"
    pkgshare.install "examples", "data"
  end

  test do
    cp pkgshare/"examples/helloworld.cc", testpath
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      project(helloworld)
      find_package(Ceres REQUIRED COMPONENTS SuiteSparse)
      add_executable(helloworld helloworld.cc)
      target_link_libraries(helloworld Ceres::ceres)
    CMAKE

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    assert_match "CONVERGENCE", shell_output("./build/helloworld")
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index f53e9981b..af932c6a7 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -234,17 +234,9 @@ unset(CERES_COMPILE_OPTIONS)
 
 # Eigen.
 # Eigen delivers Eigen3Config.cmake since v3.3.3
-find_package(Eigen3 3.3 REQUIRED)
+find_package(Eigen3 3.3.4 REQUIRED NO_MODULE)
 if (Eigen3_FOUND)
   message("-- Found Eigen version ${Eigen3_VERSION}: ${Eigen3_DIR}")
-  if (CMAKE_SYSTEM_PROCESSOR MATCHES "^(aarch64.*|AARCH64.*)" AND
-      Eigen3_VERSION VERSION_LESS 3.3.4)
-    # As per issue #289: https://github.com/ceres-solver/ceres-solver/issues/289
-    # the bundle_adjustment_test will fail for Eigen < 3.3.4 on aarch64.
-    message(FATAL_ERROR "-- Ceres requires Eigen version >= 3.3.4 on aarch64. "
-      "Detected version of Eigen is: ${Eigen3_VERSION}.")
-  endif()
-
   if (EIGENSPARSE)
     message("-- Enabling use of Eigen as a sparse linear algebra library.")
     list(APPEND CERES_COMPILE_OPTIONS CERES_USE_EIGEN_SPARSE)