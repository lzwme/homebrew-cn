class Libre < Formula
  desc "Toolkit library for asynchronous network IO with protocol stacks"
  homepage "https:github.combaresipre"
  url "https:github.combaresiprearchiverefstagsv3.18.0.tar.gz"
  sha256 "42ba0f8358739da47b5702f2c1c14ecac04dde41e20dd21c1e4a826514366efd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5deab5dfdb17c7571d469cd3f620240ddadb36a2e7735c6006c6a533601b3c89"
    sha256 cellar: :any,                 arm64_sonoma:  "faed2c5031f1c9a4ba57ea18941120f9db4d334a4a7cdaefd5fcf645617cfe71"
    sha256 cellar: :any,                 arm64_ventura: "dcf8a0c0081640642693dc11dee5a91cc9639d62f089e8245f291a71a6dec95a"
    sha256 cellar: :any,                 sonoma:        "7c503ec5ad67b6abb81b6f19020e649fa807eabb55d75e525e070df3358c0a31"
    sha256 cellar: :any,                 ventura:       "2fec1095385f92a0e59d6b707cc7cc7928090fbacecfcd5092593b317ec9017a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4ac75d6b2815dc6a4c7e8dc78d6b2199b88f717a40267b7bccf8936298947d2"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdint.h>
      #include <rere.h>
      int main() {
        return libre_init();
      }
    C
    system ENV.cc, "-I#{include}", "-I#{include}re", "test.c", "-L#{lib}", "-lre"
  end
end