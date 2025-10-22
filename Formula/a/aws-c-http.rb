class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "0e513d25bc49a7f583d9bb246dabbe64d23d8a2bd105026a8f914d05aa1df147"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34371a2a5d2b0cbfe0fdebb2a02842d4bed94e69d5dd770c230c439c0e9a6404"
    sha256 cellar: :any,                 arm64_sequoia: "f05592ee0f7e8d071740da32c0b8b763481c282b0261919a4a01ec6d529e9f2f"
    sha256 cellar: :any,                 arm64_sonoma:  "e857bed98efd2d2a9767613533a38d7ed730efc44ad825bdd8796e822b8c9939"
    sha256 cellar: :any,                 sonoma:        "cc377bd2504aff81b46028b71a7a5c559b4d21e9d885cf615e55e3b2019db309"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0009e2c7026b44fd2156021f5ae7abf37c7d8115edb8424390893d46f29ef13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b173f2666f55f514e251bde0bf2945c4674e1312eac8a8590354e9be0f09e098"
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