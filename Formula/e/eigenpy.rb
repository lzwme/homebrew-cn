class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https:github.comstack-of-taskseigenpy"
  url "https:github.comstack-of-taskseigenpyreleasesdownloadv3.10.1eigenpy-3.10.1.tar.gz"
  sha256 "7b4ea31c8eda2eeba6b1ebb22ebfe72b650e04da20e6ef48d48008c2afb1bbc4"
  license "BSD-2-Clause"
  revision 2
  head "https:github.comstack-of-taskseigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2181105e8918cc0830f2b8bb38e68e659cb05e24762e4dc556f632870a376f0d"
    sha256 cellar: :any,                 arm64_sonoma:  "3ff9c1dc7bcd49966cda52dfe41c95c96883bbb269b900c97b0f41f2cf04b38b"
    sha256 cellar: :any,                 arm64_ventura: "7bfa00ad89a7ad3b8da8e8260cf2a2ca949c21362104b953a54b1ff8be7575f7"
    sha256 cellar: :any,                 sonoma:        "209161f440d88b9100949353df8e9d8ac0f5d37ea7b76848cd6576fe7add14f2"
    sha256 cellar: :any,                 ventura:       "a2e020cba8575e069537befe9dd26113e0dac9833e0ae0de7c54f12e5089dd3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aaf303a225e46d59acad36a29648a77fbf95ed22aadc3eb2036017bd0ef66d9"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.13"
  depends_on "scipy"

  def python3
    "python3.13"
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