class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.10.8.tar.gz"
  sha256 "214b64fe47a1eb3abab7d00a002af6668700ee51c5bc2f04f01335c94bd23425"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a381e7215faf27f5ce4b03263c9df44272cb959e53479bfefafd83b766aa0d2d"
    sha256 cellar: :any,                 arm64_sequoia: "5062a2299a55ee221f07a8a676ebf2aeae8495698e6fc5aec4bac623b3802402"
    sha256 cellar: :any,                 arm64_sonoma:  "faa14a5f00fcdf6437a1e0a232811f18b7858b7cdb77826b0ffd532e8b6192dc"
    sha256 cellar: :any,                 sonoma:        "fd59b5e8daec21f98bbde8a386d7c5972d74308742fdc76177d566e9d90eee2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72508f7bda52657e590ae2a266f7c1741c4ebd8ba09ff8af082a98118e662274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67cc154eb3b2db94a3b261d2154e36a5697f5a82ae169115496dc710ce843285"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-compression"
  depends_on "aws-c-io"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/common/allocator.h>
      #include <aws/common/error.h>
      #include <aws/http/request_response.h>
      #include <assert.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        struct aws_http_headers *headers = aws_http_headers_new(allocator);
        assert(NULL != headers);

        char name_src[] = "Host";
        char value_src[] = "example.com";

        assert(AWS_OP_SUCCESS ==
          aws_http_headers_add(headers, aws_byte_cursor_from_c_str(name_src), aws_byte_cursor_from_c_str(value_src)));
        assert(1 == aws_http_headers_count(headers));

        name_src[0] = 0;
        value_src[0] = 0;

        struct aws_http_header get;
        assert(AWS_OP_SUCCESS == aws_http_headers_get_index(headers, 0, &get));
        assert(aws_byte_cursor_eq_c_str(&get.name, "Host"));
        assert(aws_byte_cursor_eq_c_str(&get.value, "example.com"));

        aws_http_headers_release(headers);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-http",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end