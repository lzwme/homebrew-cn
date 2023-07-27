class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-12.6.1.tar.xz"
  sha256 "7277d5e2f2bd95a889888f31f58e48142148f9a466b3013a5817d4506c05ecfd"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0c76bc40750cd10f1a486d45ee190974d1f4b39749c788701a97859c5edc14d8"
    sha256 cellar: :any,                 arm64_monterey: "a2ec2865f85b29c6e0e746c1175480828bc00bfe1f21272fec91b998546a23b0"
    sha256 cellar: :any,                 arm64_big_sur:  "6fdefa57c8fcf0eadd87ac09523ae591565eeb126b18db6b16e851778592a879"
    sha256 cellar: :any,                 ventura:        "a7d4f0c7c336142a62dafe8fb301fd3b1be2a00640c1a1923fe12874ae2e2e1a"
    sha256 cellar: :any,                 monterey:       "9c9a9ce9c5f98c5fb8b5e7955ded0c84eace982a8bdd41cfbf8ba6d249ff4b48"
    sha256 cellar: :any,                 big_sur:        "4da788810dd1423c01c559d845002a2ff2858f584d1fd333650e31576305390d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5f8d5c9f74813a7bfdb480fb6a069820451e843604d484bf66922a44c53193c"
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