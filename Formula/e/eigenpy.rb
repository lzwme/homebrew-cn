class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://ghproxy.com/https://github.com/stack-of-tasks/eigenpy/releases/download/v3.1.1/eigenpy-3.1.1.tar.gz"
  sha256 "3e2b2c3cd78f163f4d96bee008124ebe3369c6bab8db3c055c1cb239e49835b7"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6abc733c13d9a8f5e21c5b3ee67de10185b8c15eb609d001d7afde3037637aee"
    sha256 cellar: :any,                 arm64_ventura:  "1d25908e5cd490a0dc4111d3da3da75e8de290de0ebef2460ea2045814280c55"
    sha256 cellar: :any,                 arm64_monterey: "0f3eb4e307812e11bb33fa9352cd78e7029b99a958378d840c470a0375a04f07"
    sha256 cellar: :any,                 sonoma:         "5f51f477d3b45d54b8f0a1219d81a224383424e0b8c8d025bbfdc897ae738c97"
    sha256 cellar: :any,                 ventura:        "67a61ed7b253456dc1c7064cc6aacc66c50f848496cc2e8b84388b32e8ebc11f"
    sha256 cellar: :any,                 monterey:       "e018c3537862239a3c426ff38625971bc9ae671723624c171584c66275124138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "374e3f6f10d9b69de30d6d41a3359e17ff873dcaa8b4202cb84ae2c39f849d8a"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

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