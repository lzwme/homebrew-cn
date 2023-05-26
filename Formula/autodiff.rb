class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://ghproxy.com/https://github.com/autodiff/autodiff/archive/v1.0.2.tar.gz"
  sha256 "a3289aed937a39a817f76e6befa0d071a3e70a5b0b125ec62d1acf1d389e2197"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9525d9d0b512d0768df8fe0380e1bd47b4ebe23b7fe027395c4eedc37e4cfe5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "051a4b2ae6cd5979dc7fe1f9576ed6d10dcc0fa282261b8c42d4633a215ee1b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecc0cb5864bc2abbd0175565a63d8256ce8c41720fa847e2e7628edbe9cadbaa"
    sha256 cellar: :any_skip_relocation, ventura:        "0f09af90c0b15387cf88bbbfa0b6f2ee6b6ac2450c0c2b0d8e41d2519d4714c9"
    sha256 cellar: :any_skip_relocation, monterey:       "82d9b04329f5aaf8187050c27f6f418c1128e5359c46efb5a3a5ed7d3b66351e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f42ad6f6e8ccc2064a8aa8b16fbdf83177b78cf4068701f39eaa6c819d9bfa7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74b03caab05c7e6d3652e0d0970edc0231ab2cafa2e183a0f66633b270e9fb8e"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "eigen"
  depends_on "pybind11"

  fails_with gcc: "5"

  def python3
    "python3.11"
  end

  def install
    system "cmake", "-S", ".", "-B", "_build",
                    "-DAUTODIFF_BUILD_TESTS=OFF",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
    (pkgshare/"test").install "examples/forward/example-forward-single-variable-function.cpp" => "forward.cpp"
    (pkgshare/"test").install "examples/reverse/example-reverse-single-variable-function.cpp" => "reverse.cpp"
  end

  test do
    system ENV.cxx, pkgshare/"test/forward.cpp", "--std=c++17",
                    "-I#{include}", "-I#{Formula["eigen"].opt_include}", "-o", "forward"
    system ENV.cxx, pkgshare/"test/reverse.cpp", "--std=c++17",
                    "-I#{include}", "-I#{Formula["eigen"].opt_include}", "-o", "reverse"
    assert_match "u = 8.19315\ndu/dx = 5.25\n", shell_output(testpath/"forward")
    assert_match "u = 8.19315\nux = 5.25\n", shell_output(testpath/"reverse")
    system python3, "-c", "import autodiff"
  end
end