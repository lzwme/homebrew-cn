class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https://github.com/awslabs/aws-c-s3"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-s3/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "8287e25d8ef82e7ad2896a2b243117c4cd4a4a7890595d2484b84f1eb1fded46"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "56829a6746468e5c8d255b8848db3180d35bdbcb38f52d9c8f3e7dbac2b52de4"
    sha256 cellar: :any,                 arm64_sonoma:  "898c61e4ebe17c3c69babad3aa126ab03f8cece8fe2b839ae5d11e216370e642"
    sha256 cellar: :any,                 arm64_ventura: "284b8c01d5aab8b21ffa8fce743a04ca0b0ea4bda21d49c16bc49ae58e95bc46"
    sha256 cellar: :any,                 sonoma:        "fcd3b99d3cde4676c0ccce275144ea53a65f6fabae49dc1c53914d171306ecc5"
    sha256 cellar: :any,                 ventura:       "a586ba647ca8a84acbfbfeadb9145a0c7b1c1a46a2e70a54249b150ba58b8674"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d95886c113846b38b8926f8862b0a47a85eb05b02b5e3a979d9e40bb6bf2250d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fdb3c385b65ad7df1c137155f5295fe76819093ea022f8e5d226f89e1e41dcd"
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
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end