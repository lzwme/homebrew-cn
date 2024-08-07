class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-14.0.2.tar.xz"
  sha256 "248e2535fc092add6cb7dea94fc86ae1c463bda39e46fd82d2a7165c1c197dff"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "89beb28d09c6c5efe6795bfe6febfed42d7920e27438977d830caac52812e039"
    sha256 cellar: :any,                 arm64_ventura:  "fe4521d6e9697c7afa415c70da0d673c6d8f93b4872f2fc057a137aa838aa1d0"
    sha256 cellar: :any,                 arm64_monterey: "c7a668ccae222de69bd3a63b7fee1b0e1561c04be789040d1e851454bae9bbad"
    sha256 cellar: :any,                 sonoma:         "e05d1d348dd7990800e71422e2c4863ecbb790fc7df10715144e380b5dd98f92"
    sha256 cellar: :any,                 ventura:        "9f1ca4819eacd856d56115c681a184cfc68dc30a13e2872b863f47c9bdebd362"
    sha256 cellar: :any,                 monterey:       "efb251176fcb63706e12857de31d14a1cd8b8aa2e292225f6d2b716cffa8f9d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6afc07f17829c04a6d67492f9637268f14da1a32bafaffa6fc3def0247736ed"
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