class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https:github.comstack-of-taskseigenpy"
  url "https:github.comstack-of-taskseigenpyreleasesdownloadv3.5.1eigenpy-3.5.1.tar.gz"
  sha256 "f01eb2df88f3f470d7bd0c90716170e59f1495f5631525646c9f9378db5c127a"
  license "BSD-2-Clause"
  head "https:github.comstack-of-taskseigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a3dec33ee46632ef17c2fc744f791006a9486db8c051d6c9c2cd41466128e32c"
    sha256 cellar: :any,                 arm64_ventura:  "775064a9442703bae0f1cddc43afa5b6bf3a7aad534a5cc0f7457e79eb15c8d9"
    sha256 cellar: :any,                 arm64_monterey: "df803549e3852bf46c568892a4e8fb1c5a7289eb90697fcbb457eacc58396409"
    sha256 cellar: :any,                 sonoma:         "9b445168e87f4e5dcf844dbb2d5a80706f23cdeb138090a06709895739d0a38b"
    sha256 cellar: :any,                 ventura:        "e675f09abdd6bd844db0b72fcf2adb59debcfbc3482a99f915fe78c8ab796fb2"
    sha256 cellar: :any,                 monterey:       "f457604ea68d0a276ce35e6e53a729feb86be1c8c982c016c50e30bb136bbba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7137d6025342f723d8f12943d08eadac148b98a1ca6fcf3ac4d38a8817c0eca4"
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