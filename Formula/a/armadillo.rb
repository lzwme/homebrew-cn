class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-14.2.0.tar.xz"
  sha256 "1b5f7e39b05e4651bedb57344d60b9b1f9aa17354f06c0e34eac94496badd884"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c3c5b32b9b1c89243d51a1382fcdd81aed6157aa5663da785e9bf8241bd074f6"
    sha256 cellar: :any,                 arm64_sonoma:  "fd9181525797ffda355744dc64883580b731ff23ab9a3a941592ba10c4e5ce03"
    sha256 cellar: :any,                 arm64_ventura: "ac1bbaa49be0842a30ce50becbb823a7ed6e8b4fc6e682efbca08787fe2ac81f"
    sha256 cellar: :any,                 sonoma:        "0e1e23278d919306e5f7121897e55410ef7b40990dc448ed7dbabc9e5aef29ce"
    sha256 cellar: :any,                 ventura:       "3a2b4f39a4bdc51950a3fa131280d8b6c3e075d480c5afb5087ae95160ca5b48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed01b0bce503d462a3ea3b8d8f40c04283274035fac52b1f35a7e1f6523db661"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "arpack"
  depends_on "openblas"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DALLOW_OPENBLAS_MACOS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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