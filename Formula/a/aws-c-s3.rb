class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https://github.com/awslabs/aws-c-s3"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-s3/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "1d7c0fea455d0064f74b95c6cbd8d2a07bbc63a9040e7fea76842eef30926cfa"
  license "Apache-2.0"
  compatibility_version 7

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5f646912c43d6a658437de46daedc0bbf25391d944aa910f50d3d68d5ac7506f"
    sha256 cellar: :any, arm64_tahoe:       "62b3d1ee5af009b59f0ce54403a95e1eb6176204598c855c5cf739b59f64a470"
    sha256 cellar: :any, arm64_sequoia:     "1aa1a809f81deceea8798b79d0283259d2e8190dbc0d050ae3bb5efc183ea2aa"
    sha256 cellar: :any, arm64_linux:       "7911d1e7b316b04ae4bd4c1fac66c68ff825a5c89c1d2e94ad9a92777a3b17b1"
    sha256 cellar: :any, x86_64_linux:      "a4fb665e5dd146f43ead87f4c21df41948f5d9a9857f442f261f0aead35714b0"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-auth"
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-checksums"

  deny_network_access!

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