class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-15.0.1.tar.xz"
  sha256 "f520a0d50bbafccd7b9e793321cd7ffed374695c2e38bbdfd428841745e04c37"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6a5f0ae8b20a358ca778f71d75d875e86c95074057b92a6152118d535bb3b640"
    sha256 cellar: :any,                 arm64_sonoma:  "b02aad684338c71dd223c99d94316762cdf34171263e94037ae5d02c0f314033"
    sha256 cellar: :any,                 arm64_ventura: "d764b5a3c57b7ad95b139f02f03d03c4b82eef93fb122735bb13c8c562c4ce4a"
    sha256 cellar: :any,                 sonoma:        "62407e5a16caf6aa553e9b4b197faa7e031ceedddbcbb5904852b6ea4f4c8cf6"
    sha256 cellar: :any,                 ventura:       "5dd9aa049d810f5774cb5a091c38e5f266e581ff975dd0255ecf00c1a5f92a37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e37deed3d0005e83c66245b0aed7038d31285ad263a1a663f47218d6507cdc94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0c27f61fc01d37e628c7e0671dce75e5f524126782568696879db089f659b6d"
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