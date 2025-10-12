class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://ghfast.top/https://github.com/autodiff/autodiff/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "86f68aabdae1eed214bfbf0ddaa182c78ea1bb99e4df404efb7b94d30e06b744"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "620d8b6c709a47b79892842ddd6ccb12fd518d4de40c9a8a5cf43ee0d688afce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08fce1d7e81687a7751b642e63983eab3c04677c94d80a4745523420a9fb9c4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63d28eb9d409228783102de73da196e27a2f97af4dd4cdabc9e44fcd123f4d8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1431aa37ae2bad5dbe3336eb2608b6a2efd6ed76ddc2b5994938ff543573979"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ab3130497e5656c57d72ae83e0c1a76471f6c2ffaae4950da86e0a7f3cf2d89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9ad4d0597d5f21df158b275b08414b38aed0064e183eed63fa277c62a9fc790"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "eigen"
  depends_on "pybind11"

  def python3
    "python3.14"
  end

  def install
    args = %W[
      -DAUTODIFF_BUILD_TESTS=OFF
      -DPYTHON_EXECUTABLE=#{which(python3)}
    ]
    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    (pkgshare/"test").install "examples/forward/example-forward-single-variable-function.cpp" => "forward.cpp"
    (pkgshare/"test").install "examples/reverse/example-reverse-single-variable-function.cpp" => "reverse.cpp"
  end

  test do
    system ENV.cxx, pkgshare/"test/forward.cpp", "--std=c++17",
                    "-I#{include}", "-I#{Formula["eigen"].opt_include}/eigen3", "-o", "forward"
    system ENV.cxx, pkgshare/"test/reverse.cpp", "--std=c++17",
                    "-I#{include}", "-I#{Formula["eigen"].opt_include}/eigen3", "-o", "reverse"
    assert_match "u = 8.19315\ndu/dx = 5.25\n", shell_output(testpath/"forward")
    assert_match "u = 8.19315\nux = 5.25\n", shell_output(testpath/"reverse")
    system python3, "-c", "import autodiff"
  end
end