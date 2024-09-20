class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https:github.comstack-of-taskseigenpy"
  url "https:github.comstack-of-taskseigenpyreleasesdownloadv3.9.1eigenpy-3.9.1.tar.gz"
  sha256 "3e00b96a4fd8d4d99d28afa671b7d407c07354555d6b6459d5b7ef468a4c5d71"
  license "BSD-2-Clause"
  head "https:github.comstack-of-taskseigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "197e57d9c2a031c4ddf69d456c11111a85240a9c875b0f7687376559b9eed21d"
    sha256 cellar: :any,                 arm64_sonoma:  "017ee471096eef2a90edea7578d0a67c66f6ee76304b462f1f007fb06f35a65e"
    sha256 cellar: :any,                 arm64_ventura: "904ea4655b022f706ce899487abe75771d34abadd58cd72823fed04771c54405"
    sha256 cellar: :any,                 sonoma:        "abf02dd75cb39ac8884815f400df672038fb6d5a159399975aa7b0522b744c2a"
    sha256 cellar: :any,                 ventura:       "ad1a19fda68706580f43a0291649c2150fe19460a715efc620b27295d19da411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6514de70dad0322c1cb93128b1dc4f48692cda8f42f4ae087821ec40bc3b48f4"
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