class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https:github.comstack-of-taskseigenpy"
  url "https:github.comstack-of-taskseigenpyreleasesdownloadv3.10.3eigenpy-3.10.3.tar.gz"
  sha256 "ebfeef7a1974d9ef997a963d5e1b4500c0cbcfd6e2b5391176a8021624b3e126"
  license "BSD-2-Clause"
  head "https:github.comstack-of-taskseigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f91ccf704ca0be672a5dd0cdd717932d47aaadc0da341161f18d1fe1016a55ee"
    sha256 cellar: :any,                 arm64_sonoma:  "2fa1b0ff99a80285c38242cd8d5e897b08008685ba4bc5b1b635fd756c2f86ee"
    sha256 cellar: :any,                 arm64_ventura: "a4b65834d9b90114926641995130d131a39a45c02841a28c09716dfda3a36bf1"
    sha256 cellar: :any,                 sonoma:        "5dec65c481a651e44b360fcd893f40dbd4b076b7dfe9037a1d7a6c7ea1efb169"
    sha256 cellar: :any,                 ventura:       "9b109d518d5a28777b69a878acf89b0c9c095ec1dd3fe817fa8f01b0709b2413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8ffbb57aeab9c4fd0340a28326d9c8a25b417c4a29c0b1f9991c3a26342e7ff"
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