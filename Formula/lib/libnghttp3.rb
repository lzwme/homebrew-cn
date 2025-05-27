class Libnghttp3 < Formula
  desc "HTTP3 library written in C"
  homepage "https:nghttp2.orgnghttp3"
  url "https:github.comngtcp2nghttp3.git",
      tag:      "v1.10.0",
      revision: "481af9b0575b41954f421d1cbf3bc5ba5d35b611"
  license "MIT"
  head "https:github.comngtcp2nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c10e5300e26772d061d31e7b3afc006787a53229d7300b872e722e9fc977b312"
    sha256 cellar: :any,                 arm64_sonoma:  "ef968af785950de6dc888abdc5774d6b45c18eb4741721a8ac8609f2693b460c"
    sha256 cellar: :any,                 arm64_ventura: "a72fa85eafa74c918b8fcf01ec272c97cc8bf7aabe6079a9443bc7371a9dfd3b"
    sha256 cellar: :any,                 sonoma:        "4b90e2e9d05e78dbd65646955246de3990401b3670b28a2cf3142e1c426d267d"
    sha256 cellar: :any,                 ventura:       "8e473e4e860d0ded41c6eeb8489d7ba35473962543ea0e5e7cc09f5abc1c3a2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03a7bcc38b7beb71ef7c2d07ba618d58777ff31329bf55bfd217f6e2a99f5a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "def1333b041f7cd7905d06ac4c7bb64a865f82458a5acfa3196485f9bbab41aa"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test

  def install
    system "cmake", "-S", ".", "-B", "build", "-DENABLE_LIB_ONLY=1", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <nghttp3nghttp3.h>

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
    system ".test"
  end
end