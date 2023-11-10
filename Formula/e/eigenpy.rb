class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://ghproxy.com/https://github.com/stack-of-tasks/eigenpy/releases/download/v3.1.3/eigenpy-3.1.3.tar.gz"
  sha256 "81cf37cc12d75820a51acaf247a8aa58855db171257a87460feb76b3a4dd4eaa"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "85f21d75153b6790bc2145bc36620094b9c3c7a31af1cf8087a2f1d310a033d7"
    sha256 cellar: :any,                 arm64_ventura:  "c14317ed52e602c19bb203b2a3c31845f5242da0edb9b48a6fdd29f6446a09d3"
    sha256 cellar: :any,                 arm64_monterey: "6018af425d653c55da3524337c46e516f7cf904b051c123261a9cca1bc975182"
    sha256 cellar: :any,                 sonoma:         "488097b8aeecfa4dab3c3a95a59cf01fa9bbbebba0b9d7ee747c0504e6aa7d70"
    sha256 cellar: :any,                 ventura:        "a68be8103c5bcabf1f15015b2adc32097c67b0f2cd5ca13382318696874a4092"
    sha256 cellar: :any,                 monterey:       "98c8efb35b531dda2e4efb9473681a5d27d1b623bfaefb93eed2fc099aaaa1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75c68ca73ec94cf17f2f0504177fed9773d7d5d3c39674dbdd2f325944ddcf02"
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