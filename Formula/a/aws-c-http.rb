class AwsCHttp < Formula
  desc "C99 implementation of the HTTP1.1 and HTTP2 specifications"
  homepage "https:github.comawslabsaws-c-http"
  url "https:github.comawslabsaws-c-httparchiverefstagsv0.9.5.tar.gz"
  sha256 "cbdb8411b439677f302d3a3b4691e2dc1852e69f406d3c2fced2be95ae2397f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "631309ee7d6940853ef16c8f98a816eff4ef8cd10de567a03b0ff3979b4bb1e6"
    sha256 cellar: :any,                 arm64_sonoma:  "767fdc8ff48a9d7134d58be4438cfe45af7da88dc17f0632fcb9b3e918f8fd33"
    sha256 cellar: :any,                 arm64_ventura: "4b2c288a21d470db79cd2d78a6bb7caf7a99435afb920b6c908f93ec0034cec2"
    sha256 cellar: :any,                 sonoma:        "5c0ebfd3c8d8f83e9e21270996a065cb623aa42f74c7e9d7755c6aadf3a88374"
    sha256 cellar: :any,                 ventura:       "7264eabfcb98b8b63137fb7f12c33a7f3d90e2eb454bb7cce71c593edbff6d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "accca6e2fd410c53753b1c977fdf84f59f9dbcb0e56ff4b11aa5a5c414d49279"
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