class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https:github.comstack-of-taskseigenpy"
  url "https:github.comstack-of-taskseigenpyreleasesdownloadv3.8.0eigenpy-3.8.0.tar.gz"
  sha256 "81b8d6a44fe57c14cb4b99defd0621d862cf416fab70e1f77575446739c91e38"
  license "BSD-2-Clause"
  head "https:github.comstack-of-taskseigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e1ae6bfaac9b87d57fac8b36a60ddf735de5594056147f7a3a2af7c572e9a047"
    sha256 cellar: :any,                 arm64_ventura:  "5f58e2f0ec7eacc0bc1a74976e018f04880a138ae21978311314862683f5b21d"
    sha256 cellar: :any,                 arm64_monterey: "9f6414b68b43d7d2cd0cb887ed71f952714b6457f241ccea65de9a5258ddf453"
    sha256 cellar: :any,                 sonoma:         "4d28dc41f45082569d16e36b8f8deda4753ec89f0cbc71ec0576b0856e6b5c68"
    sha256 cellar: :any,                 ventura:        "7d005e45ce2ef36b56e5bfa31afed5d00d7eae079a65784f6988a4d2961cf406"
    sha256 cellar: :any,                 monterey:       "b7c93dcba67693ce59c90c19270dd0b873b37712b9ca5a907de57670bc15ab85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d65b011d10132b31859c2657b4412924755def259e285cf26d551c69a454160c"
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