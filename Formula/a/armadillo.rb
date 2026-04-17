class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-15.2.5.tar.xz"
  sha256 "5b5f505acef9bfd8ca78b698378a206b12abe8981851b61ae8964fb92b100f36"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9722d55d6f314331cd0d6855fce44baab121a34f015b4894d5dab4d66717cf0b"
    sha256 cellar: :any,                 arm64_sequoia: "09c49a778585d30f2052943e17b8cf2120a0451fa6464fdd76c9355df4e23985"
    sha256 cellar: :any,                 arm64_sonoma:  "b465e9cee06c713ffaf74e52659774481febdbd586bf7980374340f11de4566a"
    sha256 cellar: :any,                 sonoma:        "8101b870c985d1d88cfb225cb20681430cad047530e8c731d545cbd978f79e98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85db5b405a570ce63b906c74d3e6a681ea7e376830d03a88d744d5394227d201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efac403d2af23c04b352d8148d949eb22bde9ce22ae67c766ef49b245d0ae426"
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
    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal version.to_s.to_i, shell_output("./test").to_i
  end
end