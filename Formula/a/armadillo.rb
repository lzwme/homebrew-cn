class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-14.0.0.tar.xz"
  sha256 "8a3586b33277e6dbc3c8f27f4fff52231c2c6f7614191c190c66fb9b78ba98b5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "39b53cd4a74bca2bf825fd3a11f50b60db901f3c8afa7bb505948a13d8de61c2"
    sha256 cellar: :any,                 arm64_ventura:  "cc87027909010426e12d405ea495be9bc5c031faa3cca16701d9b754d56cbdc9"
    sha256 cellar: :any,                 arm64_monterey: "08a39033c7f0d6d1358b71f754641aab471beadc54c9186e7c58b402f4cd45e5"
    sha256 cellar: :any,                 sonoma:         "9966291fcf184f8040f371aaa6c186edb11e0aa242f0f419161be3da76b1f4fc"
    sha256 cellar: :any,                 ventura:        "459ff7dfec2fb75ade43d28f365a0e908f96e7bf5a155808a73ea4acd23fdf77"
    sha256 cellar: :any,                 monterey:       "573042629a51db485b96f08ef7de081b1e5158cc6a5adc138df304ca261f6f09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eeccdd19c8e4a4a69042ed7265d74a2a80c4888dc7f54fa959156942c71bf7fd"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "openblas"
  depends_on "superlu"

  def install
    ENV.prepend "CXXFLAGS", "-DH5_USE_110_API -DH5Ovisit_vers=1"

    system "cmake", ".", "-DDETECT_HDF5=ON", "-DALLOW_OPENBLAS_MACOS=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <armadillo>

      int main(int argc, char** argv) {
        std::cout << arma::arma_version::as_string() << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal shell_output("./test").to_i, version.to_s.to_i
  end
end