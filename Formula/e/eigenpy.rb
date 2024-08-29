class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https:github.comstack-of-taskseigenpy"
  url "https:github.comstack-of-taskseigenpyreleasesdownloadv3.8.2eigenpy-3.8.2.tar.gz"
  sha256 "a451b2eca0a634d373f4d1457c161d7d30616121f7635f2f38e8ef45e12c1300"
  license "BSD-2-Clause"
  head "https:github.comstack-of-taskseigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "db2a53633c0d8cb9f00d8ca761fbc8843dae81bd5136fba8ee252df6bbcfc700"
    sha256 cellar: :any,                 arm64_ventura:  "d60c0792dfef385ba10c7ed7ab926ade42f328f8165da3b44cadcb6913a39874"
    sha256 cellar: :any,                 arm64_monterey: "a84575e8f05826dd10f84cce3100311ffd8a4ca0480df2e49351f4a8ccfc8988"
    sha256 cellar: :any,                 sonoma:         "8801304c0dcd846230cd5f49366f7a5fe866fd2948294aacdecc4c10204ef077"
    sha256 cellar: :any,                 ventura:        "7fde61d254cc4ede51d80e5ce8f08b456ef224098b3640601a6cae398e5eba44"
    sha256 cellar: :any,                 monterey:       "cdc970cac504ccb7b68b6bb25b3c3a8620c53dfff46f1fe7b118d101d0cb21e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82984a0935ae68f3d13bb4da81fefcc709b883f14f367e435f03442ee1f0765d"
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

  # Support numpy 2, upstream patch PR, https:github.comstack-of-taskseigenpypull496
  patch do
    url "https:github.comstack-of-taskseigenpycommit98ec8fe8b2bcdde5b1fe2a85660cd7b7761e9e36.patch?full_index=1"
    sha256 "fb32fd117fcd7d3bbbc751cb850fa2a8a3121a695f70269bce935352592d9067"
  end
  patch do
    url "https:github.comstack-of-taskseigenpycommitb36cded3d855557bd69f63b215b9c45ecb8b0255.patch?full_index=1"
    sha256 "ab5f5cfe66d23a1128de4340f49de28487b1ae7082bc48e71b68521fda540e5d"
  end

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