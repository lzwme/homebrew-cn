class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-2.2.0.tar.gz"
  sha256 "48b2302a7986ece172898477c3bcd6deb8fb5cf19b3327bc49969aad4cede82d"
  license "BSD-3-Clause"
  head "https://ceres-solver.googlesource.com/ceres-solver.git", branch: "master"

  livecheck do
    url "http://ceres-solver.org/installation.html"
    regex(/href=.*?ceres-solver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c74e3b4365f764685510b4d277b5c945ccfc4efc524b6dc3d03166d379307989"
    sha256 cellar: :any,                 arm64_ventura:  "92ab34d7e35dbe1f015b20284eaa2810b69c6146307d1665a72cfb9199d2a0a6"
    sha256 cellar: :any,                 arm64_monterey: "1201db06e07cf8aee844b0438996438c48f0aadf49c5601b53d1eafb3552fbab"
    sha256 cellar: :any,                 sonoma:         "e14d6739f2b7d650b277cfa6c2ebb3b06a84f13b6a1e28e5c0d5e5c388f26a88"
    sha256 cellar: :any,                 ventura:        "c6ae823b78ee89841d53dfd421e24408c079edebad9c069ff5c0161e9931f858"
    sha256 cellar: :any,                 monterey:       "29ed4fd9c6640e86b39ec981d62f3c536da8c8d9206e5356ee006ee2aa5163bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b1d5e0e8e50982f533b525b2301f68a814767bac2629e4a5854c8f4294b6f94"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "eigen"
  depends_on "gflags"
  depends_on "glog"
  depends_on "metis"
  depends_on "openblas"
  depends_on "suite-sparse"
  depends_on "tbb"

  fails_with gcc: "5" # C++17

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
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(helloworld)
      find_package(Ceres REQUIRED COMPONENTS SuiteSparse)
      add_executable(helloworld helloworld.cc)
      target_link_libraries(helloworld Ceres::ceres)
    EOS

    system "cmake", "."
    system "make"
    assert_match "CONVERGENCE", shell_output("./helloworld")
  end
end