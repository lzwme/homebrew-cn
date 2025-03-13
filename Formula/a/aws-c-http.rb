class AwsCHttp < Formula
  desc "C99 implementation of the HTTP1.1 and HTTP2 specifications"
  homepage "https:github.comawslabsaws-c-http"
  url "https:github.comawslabsaws-c-httparchiverefstagsv0.9.4.tar.gz"
  sha256 "2282067c4eb0bd07f632facb52c98bb6380f74410bc8640256e9490b66a2d582"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "10cce95d1a974e46d28cfbf2a16b943dbaec167a899893ff47b0abacb6b150ff"
    sha256 cellar: :any,                 arm64_sonoma:  "45919bfb029d38c0c43d7fd2d8a4c794aaf380276e2a271f6ca766ad182e9b9c"
    sha256 cellar: :any,                 arm64_ventura: "fab84ec70353d2a8081241fee04a1f797beeb2801b8c93eac51b6d95e181fa19"
    sha256 cellar: :any,                 sonoma:        "39c0fc47380f7d31fbb5b46959b02c79a96ecd3f64b12327461b596c506d9415"
    sha256 cellar: :any,                 ventura:       "edadf2274bd111bda7b7ff4b80972bade9347b4986f7b8760ebdc9518e9b4b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68a8d680c509aa12eae95ebb4bb6cdb02c7edfb72bb51fee3dff45a751d2a891"
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
    (testpath"test.c").write <<~C
      #include <awscommonallocator.h>
      #include <awscommonerror.h>
      #include <awshttprequest_response.h>
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
    system ".test"
  end
end