class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-15.0.0.tar.xz"
  sha256 "4bf147cdf214c6980325b6c971d602723de494b1ae3bd1b4298d4a8312d7aa4b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "25c466b10e63bf37993fc81929ff26a6f92bac75f0282de9c0bdc2c055be35e8"
    sha256 cellar: :any,                 arm64_sonoma:  "6b8ab6022f5f84473d5316302a2ad8f81b3b81d37749ecc4ea2cd19d38bf9763"
    sha256 cellar: :any,                 arm64_ventura: "303fd4c4dd3cbe29d23dc64f448c271c18f9d1ab938e9b59a237727562e9ae32"
    sha256 cellar: :any,                 sonoma:        "da01b61cf2526d67f32e2e46b04a483260759c18a285e34da61a51787f707a58"
    sha256 cellar: :any,                 ventura:       "f6e012562bca8306cace0bab77e4c65485cd3217efc75907623a58a76a2eff8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "155b5778594138dfb11c6bd4dfd753651c5daada1c58d04645a53709c4c3cb72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0526b57692c860ad0b937589ddcac0dc87c15df9421801ed9b5fb9beb79c4da2"
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