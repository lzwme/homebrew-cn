class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https:github.comstack-of-taskseigenpy"
  url "https:github.comstack-of-taskseigenpyreleasesdownloadv3.3.0eigenpy-3.3.0.tar.gz"
  sha256 "ecfab9fe7a6a37c64c80c4ebac102ed5f072e95f696d3e9a918a8db8fc35b080"
  license "BSD-2-Clause"
  head "https:github.comstack-of-taskseigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e61d0c29817953474fd0439778f00098039a29358815732b921d47e7d0d34289"
    sha256 cellar: :any,                 arm64_ventura:  "dd6a1acfd30d070e8395d3da3835afb784fbce05990215ebcd2a1e0018d39a57"
    sha256 cellar: :any,                 arm64_monterey: "25bcf367cafecd54b5ab000e28bc86f6a1c7446e4ec5fdcdf61972b8fcbe9155"
    sha256 cellar: :any,                 sonoma:         "48d8e1d125a9e0bb8ad6c61562c72d62da2437ab7e2dfe3e3eb2c229ab57325d"
    sha256 cellar: :any,                 ventura:        "5f41352b7452bcc05c4867079104353685d5016cd9f16cc591f3ce7543dbda6d"
    sha256 cellar: :any,                 monterey:       "bd5c7ee7facfba7a12bdf88fecabe5c9b895340ced05c160c111e02b1553440c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08b3c6e44dd9e4d60900849f1ff2f6fe4913d8c240d947cce821fb4a561ab0ac"
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