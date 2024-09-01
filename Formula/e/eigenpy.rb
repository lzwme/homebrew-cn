class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https:github.comstack-of-taskseigenpy"
  url "https:github.comstack-of-taskseigenpyreleasesdownloadv3.9.0eigenpy-3.9.0.tar.gz"
  sha256 "672cd3ee675f559d0f4b32d76353fe51891ea95b0046698ce74bb9c4a54ed0f5"
  license "BSD-2-Clause"
  head "https:github.comstack-of-taskseigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e6ce07755de8a469777ce0ce1f81b48eafb029af0a42e1bfb96801c012eac90d"
    sha256 cellar: :any,                 arm64_ventura:  "8e7d16835fbeaecbf1107167f236116151c910200dba0a971710bae4fa8bec72"
    sha256 cellar: :any,                 arm64_monterey: "a0b84525d48b1a46117c5211fe5b29a7af03c4cf350ce954f9d6bcf63e28d655"
    sha256 cellar: :any,                 sonoma:         "0e2ad8b1dea780b978dbca63d24caaabae15003270696b4d4234c3ce0f76294e"
    sha256 cellar: :any,                 ventura:        "a011fe5c0d7b5d6915e7da68280744fc1d230f1f55e62443cf92a00960e7906e"
    sha256 cellar: :any,                 monterey:       "e49e92e5e66d0480eb2dc27cd188e3fa15131d2018b117a1f6d7355e7354bf3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08d1563d56cc7c2ac8f4d41ec67c60155eed0393fdeac18028677d43661b4438"
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