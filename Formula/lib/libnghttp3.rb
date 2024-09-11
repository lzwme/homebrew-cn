class Libnghttp3 < Formula
  desc "HTTP3 library written in C"
  homepage "https:nghttp2.orgnghttp3"
  url "https:github.comngtcp2nghttp3.git",
      tag:      "v1.5.0",
      revision: "750a655ae4ee8888e8724b0b6cfa7023c2e3dcb9"
  license "MIT"
  head "https:github.comngtcp2nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "c5cb90b4f447990790100f7d4ee78beb72394c0fb86f840716f7d92965b29c46"
    sha256 cellar: :any,                 arm64_sonoma:   "eabd197238ac5f48f55109a37a6aba4caef7f4fec4c547da2eb406ade5078992"
    sha256 cellar: :any,                 arm64_ventura:  "2485b36ae2feda4774dcc3292cf0d33d4125e372f164cb13779961a7ed16cdbe"
    sha256 cellar: :any,                 arm64_monterey: "ab93283b2ae44b17060d0a476d82a75c73bfe912b7570a0813f4b6c98b3d405a"
    sha256 cellar: :any,                 sonoma:         "eb86ffac56dba708fafc2313cf10af0248207d7cd8f7e80f55314cce803f60fc"
    sha256 cellar: :any,                 ventura:        "dde875020091d8a2265d3d4d3e7c23de5a853f2d7acbd09dda732ebd964832e1"
    sha256 cellar: :any,                 monterey:       "d6c32483df642130aab679dbe5910468637c445123860e348bef1c17e57d452d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e49ca806480009079c1cfbed84f2eaf1e612c79e5aa74faee94daf09abbf0be"
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