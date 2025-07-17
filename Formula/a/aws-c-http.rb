class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "04030f1529368e06aebb1ff3c97538b904c6c4b9d97e7acb8f0f26fcd39d5e71"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cdbaf146d275af10cefffdadbd09295b2cf083950aec9ef2ff214945d0200317"
    sha256 cellar: :any,                 arm64_sonoma:  "16664f0fe43fff1b729cd03bc8545bf86f0471a983ee86e473a92e0d8e7a19e9"
    sha256 cellar: :any,                 arm64_ventura: "16cfdd1c226d7e56b447bd5c9df68ca170ba3df6f39b9d0a89d66452fa60919a"
    sha256 cellar: :any,                 sonoma:        "45a47a235de62a367a4a80cc29fdcba660eaa8e52403a486fcde209c477dcd60"
    sha256 cellar: :any,                 ventura:       "956063134b28d64f7d6040119307b024c1e16e49805b378fe57d3a44df1b5220"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f3a0c2f48162a6dbe7890831f4fda1461c13654e3d65ab5d78a2270bcfbb9c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ee55bbedaa0a3817885fb020bd836eb29b2af5058486fea2258674317ca4f17"
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