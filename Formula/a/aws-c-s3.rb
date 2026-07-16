class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https://github.com/awslabs/aws-c-s3"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-s3/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "ee91aa66b776e2e1bf1eb699bfceaa9cc322be67d3e762af11d25a14122f5634"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "80a7f45c8d33983e916fc34d5e4af8372877aa4868e2c7c08f4b3bbc997132ad"
    sha256 cellar: :any, arm64_sequoia: "bac66101a59c0e21a2bf7a1d7a96e69b505f8cba966883897fe953f56190abd6"
    sha256 cellar: :any, arm64_sonoma:  "c67a5d18a78482329360cef2424358c15556aed5034c93530b19616816d481ea"
    sha256 cellar: :any, sonoma:        "9a2a13335a2012de2a0da5eb5e20e8133de7fddaaee88530d122844b231bb983"
    sha256 cellar: :any, arm64_linux:   "c6215b92ba6daa85d99714bcd1bd4d538c09a5306e68aa2e5f1b4b9cdd2818d2"
    sha256 cellar: :any, x86_64_linux:  "14944bcf7a53b2892ebe3551493f35c3851021a1ed92c636c41b7b92666084ce"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-auth"
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-checksums"

  def install
    args = ["-DBUILD_SHARED_LIBS=ON"]
    # Avoid linkage to `aws-c-compression` and `aws-c-sdkutils`
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/common/allocator.h>
      #include <aws/common/error.h>
      #include <aws/s3/s3.h>
      #include <aws/s3/s3_client.h>
      #include <assert.h>
      #include <string.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        aws_s3_library_init(allocator);

        assert(0 == strcmp("HeadObject", aws_s3_request_type_operation_name(AWS_S3_REQUEST_TYPE_HEAD_OBJECT)));

        for (enum aws_s3_request_type type = AWS_S3_REQUEST_TYPE_UNKNOWN + 1; type < AWS_S3_REQUEST_TYPE_MAX; ++type) {
          const char *operation_name = aws_s3_request_type_operation_name(type);
          assert(NULL != operation_name);
          assert(strlen(operation_name) > 1);
        }

        assert(NULL != aws_s3_request_type_operation_name(AWS_S3_REQUEST_TYPE_UNKNOWN));
        assert(0 == strcmp("", aws_s3_request_type_operation_name(AWS_S3_REQUEST_TYPE_UNKNOWN)));
        assert(0 == strcmp("", aws_s3_request_type_operation_name(AWS_S3_REQUEST_TYPE_MAX)));
        assert(0 == strcmp("", aws_s3_request_type_operation_name(-1)));

        aws_s3_library_clean_up();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-s3",
                   "-L#{formula_opt_lib("aws-c-common")}", "-laws-c-common"
    system "./test"
  end
end