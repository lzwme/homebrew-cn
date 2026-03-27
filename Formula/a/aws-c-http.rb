class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.10.13.tar.gz"
  sha256 "d8352e7a1fb1996694a4dc31219ce03452882abf8d0858c104727f975e11b9c7"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8e5bed1281096aab7af9067357e182cedb010644222f02ef047efaa4d2b7ec6b"
    sha256 cellar: :any,                 arm64_sequoia: "b2fceb6f3186999060f3d27a6889363cc23d755cabf780f2e1d537fd1a85d077"
    sha256 cellar: :any,                 arm64_sonoma:  "999930344d5f3fd073234a223e00600de7ced5ee3eb2cd34e3baff0250d19803"
    sha256 cellar: :any,                 sonoma:        "6626752d73d679103f9be1ccadc8efea835a7377060e0eddbff24adfd69890e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "989ab0303d303cc11ff176bd4e5636742077e4792b4d2d75bd8315c686ff0dc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2326d8470eb5fbe509651e9c61b5e41451e0af84b948abf31467fec905db088"
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