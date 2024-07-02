class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https:github.comstack-of-taskseigenpy"
  url "https:github.comstack-of-taskseigenpyreleasesdownloadv3.7.0eigenpy-3.7.0.tar.gz"
  sha256 "c88df6b44ccf8ac4cddc4c1015a3f1c3cbd7425cac1342f07ac16bc6f2b33f87"
  license "BSD-2-Clause"
  revision 1
  head "https:github.comstack-of-taskseigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "33717fa77182d22a9dc6cec13b400b596b97aab3b63e70adceac9fd2e1c80223"
    sha256 cellar: :any,                 arm64_ventura:  "95817dccd2c33f98ac17b53a5be7a749b05bfd7f50bad9a29ce524c852554678"
    sha256 cellar: :any,                 arm64_monterey: "5b17021cd2cb7f0377ab546fac16aa5fb61aff6a1b521b72504bd5b339f0f290"
    sha256 cellar: :any,                 sonoma:         "dcda63e220946b6991a1df2ce1d030ad3063d77a7a48b6146ec901291e0c8c8e"
    sha256 cellar: :any,                 ventura:        "dbfba41da1dd5ac8e612ea43aa499612fa4841e499fcf3831913d64d619c07c4"
    sha256 cellar: :any,                 monterey:       "d4d9de6fb0c2e55ccdf5fc3ec1fbf59e56e38dee97293a1eae7b83e4d60680d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6f84c13af52d7b0a69aea7ec2c13c3a9c108808f448a6d3c565bccbc2335288"
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