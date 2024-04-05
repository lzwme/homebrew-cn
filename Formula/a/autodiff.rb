class Autodiff < Formula
  desc "Automatic differentiation made easier for C++"
  homepage "https:autodiff.github.io"
  url "https:github.comautodiffautodiffarchiverefstagsv1.1.1.tar.gz"
  sha256 "05aa2a432c83db079efeca1c407166a3f3d190645bd3202da3b6357fb30fc9e1"
  license "MIT"
  head "https:github.comautodiffautodiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61e3797a21e5c21faa34630742ce6df1595e070e94756f13dfc0631a32231ae7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4def158137d25d2ce45cb374c5e098d3240c7303a908753a7cb8fd0ae92c41f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c0af942c9059b0733bee08fe6798a9c7096c8ae047342fafc427a86c2691ddd"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e6a25f51d0ae62b0288417b95ed9d8f970c455c958e7ab542540cb950afe17b"
    sha256 cellar: :any_skip_relocation, ventura:        "5a9113c28b7f345d11b23923fc1fd1e893ddd69694520ed0a8d484d1b8ec6c93"
    sha256 cellar: :any_skip_relocation, monterey:       "3498c287720d723317e5006038f194c34a0db5ba9e7c75024a5f1bd3f00fdca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ba452068ae5ec6cf2391442e5a1a90d8bee93bbcd5cc06ddb9f6f89df293134"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "eigen"
  depends_on "pybind11"

  fails_with gcc: "5"

  def python3
    "python3.12"
  end

  def install
    args = %W[
      -DAUTODIFF_BUILD_TESTS=OFF
      -DPYTHON_EXECUTABLE=#{which(python3)}
    ]
    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    (pkgshare"test").install "examplesforwardexample-forward-single-variable-function.cpp" => "forward.cpp"
    (pkgshare"test").install "examplesreverseexample-reverse-single-variable-function.cpp" => "reverse.cpp"
  end

  test do
    system ENV.cxx, pkgshare"testforward.cpp", "--std=c++17",
                    "-I#{include}", "-I#{Formula["eigen"].opt_include}eigen3", "-o", "forward"
    system ENV.cxx, pkgshare"testreverse.cpp", "--std=c++17",
                    "-I#{include}", "-I#{Formula["eigen"].opt_include}eigen3", "-o", "reverse"
    assert_match "u = 8.19315\ndudx = 5.25\n", shell_output(testpath"forward")
    assert_match "u = 8.19315\nux = 5.25\n", shell_output(testpath"reverse")
    system python3, "-c", "import autodiff"
  end
end