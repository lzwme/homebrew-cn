class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-14.0.1.tar.xz"
  sha256 "8346f1e7567bcb3a28dd770097208e78d33a5d41e0a71af2a7e7fd997f17db44"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5e548e1e582ad9f8071a14b1f72d19a5cebf56d6f5a72f781abc75e60197a021"
    sha256 cellar: :any,                 arm64_ventura:  "0da069b1ee1caeb250f4730a708446efb3b1e794a9d02523c2eddab9fbfbb73e"
    sha256 cellar: :any,                 arm64_monterey: "1d4a86a69eb98b67fddc2de2eb88bda302e8328f5effaefe007445f70a1b00dc"
    sha256 cellar: :any,                 sonoma:         "17d721d7792a2f3e6527f3d2e2d6ac978145825d94944e2d8fdb0288a20b18dc"
    sha256 cellar: :any,                 ventura:        "26cdf2de55bc7cf134db90287ef520c3b26bbb25d472a0b0ad1ac3fd66559582"
    sha256 cellar: :any,                 monterey:       "02a459d4dc5bfc98d0c211d808933b240d96778d95f98d54cde834ac1ad78ab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bab2f85d5389f8d04a1b72c9a400bc169083ab42c084e6f233fd51a9e2a60310"
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