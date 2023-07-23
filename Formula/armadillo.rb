class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-12.6.0.tar.xz"
  sha256 "b4102a384791af16d9e5fbb306f11fe356abfbca0a7d7ca7abbc9a8a9466102a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "05b744badda6383facc6006a2ea3073a664893ae98addca6708d5a872d5cd5f4"
    sha256 cellar: :any,                 arm64_monterey: "41bb35bb1d1ad55f81bc9621938f7de536b8ce8b5e83c7abaa226a5dafb09c06"
    sha256 cellar: :any,                 arm64_big_sur:  "2113a3468aa82b78fc2a556d31c44c870e7d123f0c8a80947a301bfc77013e85"
    sha256 cellar: :any,                 ventura:        "82623deeed10a98fb4864bebeb275138ae183108b730ea5aab894d3fa6ecf082"
    sha256 cellar: :any,                 monterey:       "dd59018dcdeba86edfadc31a721a43142890beab4bb856cffd2ff01391ce2ef9"
    sha256 cellar: :any,                 big_sur:        "f5a017afa607b1216321165331bd67987ee134f11fe86af489958c9a4b5c527c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34a803aaad9226fa77ccebaf7a243db50c57f4074557f524c6fa2b5dc6e7f36f"
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