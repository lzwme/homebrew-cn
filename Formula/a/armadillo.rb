class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-14.4.0.tar.xz"
  sha256 "023242fd59071d98c75fb015fd3293c921132dc39bf46d221d4b059aae8d79f4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0f5cbedde25655ece2b83b4f90b2f654ba9bffacc69f1d0d0cf9856200228908"
    sha256 cellar: :any,                 arm64_sonoma:  "3bf4d7eb8514597f2a3a9839d3efdfcc4c76689e3d836e2083820e1ac4f2524b"
    sha256 cellar: :any,                 arm64_ventura: "c0405c7e2bcee6d1bab7b4048da4bed2aad8277f05cdffece6c47b6ee652c804"
    sha256 cellar: :any,                 sonoma:        "fd74940e6a4ee176dd42b94e3dd8c7d43b53e5181fe3a41b07c55f7292558acb"
    sha256 cellar: :any,                 ventura:       "567b497b0e43974f47a434f17d2b0ca65838b32d2197cf0e5fa0564bf4cb470b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49f9c6ed3754971bf7332055d5881e21c735840887ecea35a48cf1ce215af3a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08f10419e278da2e82ecb541f6368edf0efafa75fdccbd5a3ea5712cc63d3cb4"
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