class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-2.2.0.tar.gz"
  sha256 "48b2302a7986ece172898477c3bcd6deb8fb5cf19b3327bc49969aad4cede82d"
  license "BSD-3-Clause"
  revision 2
  head "https://ceres-solver.googlesource.com/ceres-solver.git", branch: "master"

  livecheck do
    url "http://ceres-solver.org/installation.html"
    regex(/href=.*?ceres-solver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "313ed5690a361970bdea14a72c09a8303dc2172b84fc1d8204dbb79b913d00e7"
    sha256 cellar: :any,                 arm64_sequoia: "4e5508fed469c7de173c44f6875a93e27758aa61a1f3ee0daa1bea279b5703b5"
    sha256 cellar: :any,                 arm64_sonoma:  "4dc3d66678294486b58e513950109a4d593286eeb02d21b076de35d1aae0d126"
    sha256 cellar: :any,                 sonoma:        "c17ec0c69c71db298cc62c1447e9c108cbbd8711e676051d7768049ec6614caa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceceda8cfbf36c576474fef71487f756ee03183c20453e1fe25ba304972ee994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bf8a2f59441ee79ae0d2fab7a7cfabf6f3aec910c1c2695a215fe673bf7a0c5"
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