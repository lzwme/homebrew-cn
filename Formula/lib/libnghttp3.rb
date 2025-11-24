class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://ghfast.top/https://github.com/ngtcp2/nghttp3/releases/download/v1.13.0/nghttp3-1.13.0.tar.xz"
  mirror "http://fresh-center.net/linux/www/nghttp3-1.13.0.tar.xz"
  sha256 "926d358a74d6f15e5a11239e3e980dd4c66332e52e4d1b38c2cf8820458ad4d8"
  license "MIT"
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c2e159513b4d1416d0c95a4885beb975c84a12cc46c86542c2e233596546ef63"
    sha256 cellar: :any,                 arm64_sequoia: "672903c0888f2f2ed123017b89bef7569b93ee4e09d7077e1a916ad1882f4056"
    sha256 cellar: :any,                 arm64_sonoma:  "72da5383868e3ddd0c8aea7f0f3aa15097d48de1185baac4c66d14c0b08076bd"
    sha256 cellar: :any,                 sonoma:        "decaab14a31a3f9dde6b4b707b378ff2ea21d6598ecc2121885abe1d5d56b7ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfdd3daffbbe5da51aca1fc17b2bcb417ea2003baaa552fbed69367b5b2e38eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "581efd95ece962ddf8214128ad7ed038d7c5ed7857ea5cc4dd5c7738c9656373"
  end

  depends_on "cmake" => :build

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

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lnghttp3"
    system "./test"
  end
end