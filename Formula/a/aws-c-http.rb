class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "02e8e67f5f03fa6458f8921232dc7a9076792d2822ad86f19c3f984fc1a073a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5fb49fdf877602f25cfa11c6ab00ef498415ce599879bee1ca3de167142577c8"
    sha256 cellar: :any,                 arm64_sequoia: "02a17d76256498970189a903c4f0b174517ea0351d271004a6db20a791bb0226"
    sha256 cellar: :any,                 arm64_sonoma:  "303f1448d1836790462ce4e3fa6f378f95cf24a8bbbfb73b577f6adc39b50678"
    sha256 cellar: :any,                 sonoma:        "97e68d5006b4adc83efc1948b2a979710b0c8c108ea494dae89e89673f6b3b62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c86bfbfaf15cb8c7859f226cd05a9edf68c26dc6d9fd4815f197bd3b18a1d3e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a8a4ca65de40183ceb51f3333dcf17b71ed1431e0fb52a8430411485c0acfa7"
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