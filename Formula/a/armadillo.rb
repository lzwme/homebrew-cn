class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-14.2.0.tar.xz"
  sha256 "1b5f7e39b05e4651bedb57344d60b9b1f9aa17354f06c0e34eac94496badd884"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bcf12ed568ca7223d633382d34a18e8be0070dd5854dda53d5a9f6a3eb63db00"
    sha256 cellar: :any,                 arm64_sonoma:  "f05078b9af2241accc0ee1f803115d2cdc6ce9c7d3bc9fb63690bd5f6da0c26b"
    sha256 cellar: :any,                 arm64_ventura: "11c9c7b8713c369d272abe888a93be6e1bbfc244423a4fc313fdcfdc937cab36"
    sha256 cellar: :any,                 sonoma:        "89bc926056f4ac31dcad51fd90eaa371404b0ba01c911764941fc2889f78a369"
    sha256 cellar: :any,                 ventura:       "ab0331eff19478c95a8a95c0d10040cd4425189101aa1e4f9cc7960a18e17fdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d6c2614c5c0b65aa1a5d11467dcc48e770e6bb2bfde4a376b1338d74ba39e04"
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
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <armadillo>

      int main(int argc, char** argv) {
        std::cout << arma::arma_version::as_string() << std::endl;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal shell_output("./test").to_i, version.to_s.to_i
  end
end