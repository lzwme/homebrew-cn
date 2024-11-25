class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-14.2.1.tar.xz"
  sha256 "2495815cf9d130f70fffb6a12733d0dcaf86cbaac51e8b4b82ad25183eda1dd5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e3b9ada7e1792f062dc93a5efa9cb5f99d46bf4fad9de2a9259d4aa19a54dcc0"
    sha256 cellar: :any,                 arm64_sonoma:  "cb29567f1d3f00148400ace0246796bf49237029015f5c344ee2e21355502162"
    sha256 cellar: :any,                 arm64_ventura: "e99d210bec861f1be0778f7ff13837a0c28210d00fe3baa160f1e8d2affa5dd2"
    sha256 cellar: :any,                 sonoma:        "854b135d140174fbd49f1830adf4f99a7b212793acc0f71672b3c99b6e335061"
    sha256 cellar: :any,                 ventura:       "c31a88b86b32183757a4192e367cda439bb8e8dc2476a7219d32a11b2a333ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d75209f14e7cd860f5c411f330aefc8cfa146fc8a7f9ce7e20577bf40daf75ca"
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