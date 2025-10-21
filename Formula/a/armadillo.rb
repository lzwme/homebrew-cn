class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-15.2.0.tar.xz"
  sha256 "2f71c0661fc4a46e2dd56b7651cf3bb5928b499a4b10df31efc1a4241edf0043"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3563172d7eb49e3051a8c23673f552ba94bd2dca0e8aded638cb8e9b98507a17"
    sha256 cellar: :any,                 arm64_sequoia: "d7fec82f1090dfa9a7da2faffdbf77ee8b2d143d5bf41c00a0a99e95ad1c844d"
    sha256 cellar: :any,                 arm64_sonoma:  "15d27acff3c4b7e5703ba8f5f28a6890e707702b8cb63f0a24d9f43cbee082af"
    sha256 cellar: :any,                 sonoma:        "fdcb0936bb4d1012c32169698f3d461a1aac2d8c829165ccbb1845efd455ff2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c610689f2e9bca34974c697688d4141b71280188f5eb744c8486f1ddd2f9582c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a234c3f5df0ee6211e27488b24a8ddd5b154934d6a343fb783f84e7b29c7558"
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