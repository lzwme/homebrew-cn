class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://ghproxy.com/https://github.com/stack-of-tasks/eigenpy/releases/download/v3.1.4/eigenpy-3.1.4.tar.gz"
  sha256 "ac96e2439a6975f7942c966317e6dc19261d103725d1e01e3115be7b4ec1b62f"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "27d384c6f90d05e67ff84d85761bc58a85b125077f165076641d9744c3565d10"
    sha256 cellar: :any,                 arm64_ventura:  "4a19694c0daf771a2b4b8a0f59db8bd9c5da8821a3feccbb6671a2ef70e50a56"
    sha256 cellar: :any,                 arm64_monterey: "585b59713401109fa357e17f909f11db67e5cda423e93b5922a3f790d5f6b7a8"
    sha256 cellar: :any,                 sonoma:         "9db94dc107fec876e8622ca300efe9567ba49fb3113da964986a192cc9714578"
    sha256 cellar: :any,                 ventura:        "b54a01083b122faccfa02ef289b6cb872bfc91ae15157d36d29d20c9fe0877f9"
    sha256 cellar: :any,                 monterey:       "2a2d0d076ff5f61da5bd221033a47f06ad7c859bbd8a2d5f96784094e07f0349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37b763b9f0f1d1e32131ab1b07aea6076aa2bb55eb91486a099d357182e963e5"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~EOS
      import numpy as np
      import eigenpy

      A = np.random.rand(10,10)
      A = 0.5*(A + A.T)
      ldlt = eigenpy.LDLT(A)
      L = ldlt.matrixL()
      D = ldlt.vectorD()
      P = ldlt.transpositionsP()

      assert eigenpy.is_approx(np.transpose(P).dot(L.dot(np.diag(D).dot(np.transpose(L).dot(P)))),A)
    EOS
  end
end