class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-http/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "1540c7b51be730ee1efecabe2b6fc95c5021ab3458a8da98beb12bfd3e8eb6e9"
  license "Apache-2.0"
  compatibility_version 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "059e0606c8509e0d8b72c85795126eba0dcbc51a109f243a56adba91741409db"
    sha256 cellar: :any, arm64_tahoe:       "10be882dc4c346fc082030531f29a117d36cdd6db8052f91a958482042ff68d5"
    sha256 cellar: :any, arm64_sequoia:     "8336155f29f446f9d7dffe1c707258155f10b2855bb9c7e6198ffb53bd2b390b"
    sha256 cellar: :any, arm64_linux:       "10a3a648ad85b9a71fd3af9cd1f2719d0911a5b7435b3239da11ad4afc573ed7"
    sha256 cellar: :any, x86_64_linux:      "cc5c0d32994dd663701d49341b804e1f769e5e2330fd190b99fc57d9ccd9babd"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-compression"
  depends_on "aws-c-io"

  deny_network_access!

  def install
    args = ["-DBUILD_SHARED_LIBS=ON"]
    # Avoid linkage to OpenSSL
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
                   "-L#{formula_opt_lib("aws-c-common")}", "-laws-c-common"
    system "./test"
  end
end