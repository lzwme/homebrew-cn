class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-14.6.3.tar.xz"
  sha256 "ad1e2aa5b90a389ab714e2d00972ce64da42582b17dd89c18935358551e6e205"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f4b0122bcd1c12584184f199865c178cc0be9e6e0745bfab95542f2842d51b1c"
    sha256 cellar: :any,                 arm64_sonoma:  "32231e50d49c734c8106110b6b717d6b3aed6598daed3869d0f794a8acebcdc9"
    sha256 cellar: :any,                 arm64_ventura: "fc7ba9c6481291bff995993cddf8495bb67813722bc749f03ef036fae59c6e52"
    sha256 cellar: :any,                 sonoma:        "66f3c54ee123703a9eb9d59e624d7750e4c6d43280d50be1aeeaf474e6d77685"
    sha256 cellar: :any,                 ventura:       "c3a26de276968161edbbf33c7608c841004e6f8b243e94a80b9c78a29a179607"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fd6f67aaf46f9177e84ba995cd7930d795d6e66e3830ab7b0a3b0fa884885cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9b83ae60db02c27bc564ac5f25d22848bcf343d929cc88f0d35139f39d365f8"
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