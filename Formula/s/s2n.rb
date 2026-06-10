class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://ghfast.top/https://github.com/aws/s2n-tls/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "d2fbf45c0e039bdb6f253a392fc8bbdd258bfe0bd586f3516a2c97bb138b8e17"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4e8d684df4c4f704376811d509b47418d90293fd8930ebcd238dd666e2e33ca8"
    sha256 cellar: :any, arm64_sequoia: "cda12e1be5e745c7f53645ef0e86c2140e612c007d7596436d03ca375551a7dc"
    sha256 cellar: :any, arm64_sonoma:  "6cc4b38f738b3bd1ea9f16142e8bb20d272f2e96307c6643f0d14d07c724b25c"
    sha256 cellar: :any, sonoma:        "fc9e6f0ac2899351310591a23656af4d2a364066eddbf971dd4f53bbcf75b8d0"
    sha256 cellar: :any, arm64_linux:   "f4a9c53dfdfa858165b4645d4f9d2431654d6a3e2ce242e80c5f157bf878cd12"
    sha256 cellar: :any, x86_64_linux:  "a73955f9ba9760fb2fad36cf433e922bf68616f347d672a64e4ba612572bc471"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build_static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build_static"
    system "cmake", "--install", "build_static"

    system "cmake", "-S", ".", "-B", "build_shared", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end