class Libnghttp3 < Formula
  desc "HTTP3 library written in C"
  homepage "https:nghttp2.orgnghttp3"
  url "https:github.comngtcp2nghttp3archiverefstagsv1.1.0.tar.gz"
  sha256 "b3ffb23a90442a0eafe8bfbefbc8b4ffb5179d68a7c0b8a416a34cf04b28d7c5"
  license "MIT"
  head "https:github.comngtcp2nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "71b2c40bfe0818a6cf4b667ab750154f0731d68ff764c7b982f1a2c5936fdeef"
    sha256 cellar: :any,                 arm64_ventura:  "f5d3581f37ae8b8c3836f9f488819d9baf44ba2d35d55783e72d070e7b060ab0"
    sha256 cellar: :any,                 arm64_monterey: "d294da4c4c26491a500bb723b5ec713b408f893b2008bc1806515e5825fc3fc2"
    sha256 cellar: :any,                 sonoma:         "c0939b889c09fc6635f3cdd2df0c00d6f3fce13e68ac360088f87b9ba9df0f59"
    sha256 cellar: :any,                 ventura:        "379d7b99e07295ea465a359d46afe178d98b89f252719e0b6384c03e7b57ec3e"
    sha256 cellar: :any,                 monterey:       "2270b9a3f88efcf8d876cf3f1c7a61771b63b822c7b1db9d2be0e6e7e7ec006c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c1f4bc1624e454af1acfc2e89825991dbb522ac60971cdc36d27273e94013b0"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_LIB_ONLY=1"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <nghttp3nghttp3.h>

      int main(void) {
        nghttp3_qpack_decoder *decoder;
        if (nghttp3_qpack_decoder_new(&decoder, 4096, 0, nghttp3_mem_default()) != 0) {
          return 1;
        }
        nghttp3_qpack_decoder_del(decoder);
        return 0;
      }
    EOS

    flags = shell_output("pkg-config --cflags --libs libnghttp3").chomp.split
    system ENV.cc, "test.c", *flags, "-o", "test"
    system ".test"
  end
end