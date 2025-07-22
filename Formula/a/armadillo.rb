class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-14.6.1.tar.xz"
  sha256 "bec67f368fc61673c4c9e9429d20135a42ba80a2c7f8592b912e5f97e289bfc0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "69c3c3bd9da1428020b9eef51ff8831ff16b3f61708b1c1efc35d40418cb3d06"
    sha256 cellar: :any,                 arm64_sonoma:  "18b2f6fbd5d3c65d7a3878c90d2eda0a0381ec7983dff1228c175e8e27e3ef3d"
    sha256 cellar: :any,                 arm64_ventura: "02bb2424082eb84b8cd1d09b24a92596416a44846b315108ba8360afa25c9117"
    sha256 cellar: :any,                 sonoma:        "4fb88dd5ec63f1870252737f7c04c7f5dbdf1c4b80b868c7f761ea2c0a8f9f40"
    sha256 cellar: :any,                 ventura:       "b4abc32371401b098246d02abb7fb71517de64b646ab63d51f9d4e29f922e5ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14999ed0b55a27bcc64394fe5a98f23b14e652134ce659e7fffd8b4afd6a7c71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3570c024024dfbc22712a822ec9e3e8c1ccde1fa43f7d0b1334f16596ba8909"
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