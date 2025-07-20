class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://ghfast.top/https://github.com/ngtcp2/nghttp3/releases/download/v1.10.1/nghttp3-1.10.1.tar.xz"
  mirror "http://fresh-center.net/linux/www/nghttp3-1.10.1.tar.xz"
  sha256 "e6b8ebaadf8e57cba77a3e34ee8de465fe952481fbf77c4f98d48737bdf50e03"
  license "MIT"
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "b3dffb612eb8682d4981be3a8f614f0796a882de0f5074ccf27dd9adcb821144"
    sha256 cellar: :any,                 arm64_sonoma:  "3753ee39b5afda2ead1cf40a34d46f745d7f50155e47a491be724847698c7eb8"
    sha256 cellar: :any,                 arm64_ventura: "110a42053eb285939f7172b3fbb6262e35fae86b0ac502b5d42df152c37054bd"
    sha256 cellar: :any,                 sonoma:        "d1d738ba31e6c0bcec823614f1f41ccb551a284e7c4143091b1d88485b25bf7d"
    sha256 cellar: :any,                 ventura:       "43aa9a5e468975afad57228d1cbce16070c1a2e1a6d61db54656eff8fe45b99a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1791d72ce26a4b38f59ef61e5d5bfab264c387052b4d4e6360893b06734e263"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a67716f88d29966317a513c01536d9291602b1ead405ba1ffb4a96666ab528ff"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test

  def install
    system "cmake", "-S", ".", "-B", "build", "-DENABLE_LIB_ONLY=1", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <nghttp3/nghttp3.h>

      int main(void) {
        nghttp3_qpack_decoder *decoder;
        if (nghttp3_qpack_decoder_new(&decoder, 4096, 0, nghttp3_mem_default()) != 0) {
          return 1;
        }
        nghttp3_qpack_decoder_del(decoder);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libnghttp3").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end