class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-14.6.2.tar.xz"
  sha256 "49ddb76670b1d1a142f760637e653ec5b20ba730e7630a2f3c2b13d324c37e08"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9170ea00151d4168fc1bd1388ce9451aa95ee411551adee4c917d942c7b19910"
    sha256 cellar: :any,                 arm64_sonoma:  "eafa432dee3e76ae99adb272c60046f51557c3650755f190f3a59046d3e21478"
    sha256 cellar: :any,                 arm64_ventura: "73b6604b644a7d2eb81d8f50c3fe390ab9ebb0938e25e70dba00e44e2e18193f"
    sha256 cellar: :any,                 sonoma:        "c8b6b85d9d41280dc6455c2947f52068f75aea97699fd9cce20a65891e7bef13"
    sha256 cellar: :any,                 ventura:       "c6ca3d1d0311ef85e34a9d86345f745593504dfb01b5939e328f8887bb3616fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3ff1f225b7fd377493c31367b90cc17e051ae3892c7f2b4d588de7c413244ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "824eea5f181b6b6cd3578f7d6802287771d84410c3d43ef103c1f87b94ba79bf"
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
    assert_equal version.to_s.to_i, shell_output("./test").to_i
  end
end