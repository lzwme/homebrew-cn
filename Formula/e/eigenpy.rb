class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https:github.comstack-of-taskseigenpy"
  url "https:github.comstack-of-taskseigenpyreleasesdownloadv3.10.1eigenpy-3.10.1.tar.gz"
  sha256 "7b4ea31c8eda2eeba6b1ebb22ebfe72b650e04da20e6ef48d48008c2afb1bbc4"
  license "BSD-2-Clause"
  revision 1
  head "https:github.comstack-of-taskseigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e54f499c863e9dc6653472cdb0833cc23dd93b1e25a30e6097bbf3de1a03ebd4"
    sha256 cellar: :any,                 arm64_sonoma:  "17aedeb9538d2bd5d20741006e21d8b270b312af27b3e91c07abbb107044e6f1"
    sha256 cellar: :any,                 arm64_ventura: "61a64d934d8b3cb150183cb3a22fe1cfcd50d016eacf0f93d800d1aafed958df"
    sha256 cellar: :any,                 sonoma:        "33ad45aacbbd7a830eb89842e2debe1bc0850996486e373dcb8352edc5107a93"
    sha256 cellar: :any,                 ventura:       "2437d5ae18ebc874fcfdd3d0140370e8cc21a001989f9adc092d4e355e32096b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d811266c368c0cd20080e05c30215d9509c94bdc84979d316d564f31bdb05a7"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "scipy"

  def python3
    "python3.12"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefixLanguage::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share"eigen3cmake"

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~PYTHON
      import numpy as np
      import eigenpy

      A = np.random.rand(10,10)
      A = 0.5*(A + A.T)
      ldlt = eigenpy.LDLT(A)
      L = ldlt.matrixL()
      D = ldlt.vectorD()
      P = ldlt.transpositionsP()

      assert eigenpy.is_approx(np.transpose(P).dot(L.dot(np.diag(D).dot(np.transpose(L).dot(P)))),A)
    PYTHON
  end
end