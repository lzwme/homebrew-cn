class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-15.2.1.tar.xz"
  sha256 "a5b8109da3c169802f51a14d3bd1246395c24bbca55601760b0c96a3c0b2f8fa"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7f3c00e1620ee33575df244707f8b3c1f289530b002378ce2c29ebc70e9fe71c"
    sha256 cellar: :any,                 arm64_sequoia: "93de26dcb6df0074870e5c61409c1ce359b8ab7bd070bb0fc8841da19b8c9372"
    sha256 cellar: :any,                 arm64_sonoma:  "2d6fc08193d1ebcae41f3f94b867e26b003256bea2b8798d71307ce99da8d1ab"
    sha256 cellar: :any,                 sonoma:        "bbb7d8398b7ccf50d2695dcf6f3196931218cfe1b8d0dff65297e188d305591c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e94732daa01cc037f28d1bd459eeae5044ce9f4d41c15223477cb25d3de7d305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4755a5715ee970cf8d406e59476e66e6a741a76caad97907e07be48ec8e1b188"
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