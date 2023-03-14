class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https://autodiff.github.io"
  url "https://ghproxy.com/https://github.com/autodiff/autodiff/archive/v1.0.0.tar.gz"
  sha256 "112c6f5740071786b3f212c96896abc2089a74bca16b57bb46ebf4cec79dca43"
  license "MIT"
  head "https://github.com/autodiff/autodiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e1acf83eec90177103118d1be121354a4e6abda018ff649fdbb484af8666b70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0f03ff64c3391609bf687378cad37a524950aec693c22bf1142cb774fb8c182"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c04232f970512c81a8f3a7a358a0df2b227ba2ddbe89bcbd0dd5794d07516fee"
    sha256 cellar: :any_skip_relocation, ventura:        "80e9984e33919ab93e5cf1b763176186c820ea6ed0c22bedcec5b96405107476"
    sha256 cellar: :any_skip_relocation, monterey:       "2ec1a5a954c3529d07878dd4eb448e05ebcbf4d17bb2009d8d9ab2bd1863190b"
    sha256 cellar: :any_skip_relocation, big_sur:        "848d18d6e223c19a8a63eb252e15ad94c2484fef19a8153bec533c15e719e515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f66b909c456d3e7ace1c82671a204807cd50f6b842f1e86db887eaa962776571"
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