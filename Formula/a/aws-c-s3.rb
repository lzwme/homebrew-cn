class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https://github.com/awslabs/aws-c-s3"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-s3/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "840810fa0b09b96ef35db9608bdbe572c9451526782e057c2c2e0b0a97d4db9e"
  license "Apache-2.0"
  compatibility_version 4

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0141373a713a8db787971b067ae6fa0ab0532441b9732725d4f13a51567d2224"
    sha256 cellar: :any, arm64_tahoe:       "4fd95ee4cd2c3afa11e1f9574a0e6bd0975d8598a4975878d8307818b8a93244"
    sha256 cellar: :any, arm64_sequoia:     "df84a94d70d04accebd8efc2dcdce800d80128bcad082f60ff07ad7eeaa6266c"
    sha256 cellar: :any, arm64_linux:       "624e8a7eb92c11023e26a200ecc7f93e4e3e2a14ed64cbb2a566f7211162135a"
    sha256 cellar: :any, x86_64_linux:      "15da54fef5c1e9eafbcd0b6e7860a8fa0d9f83420eae50c8a5f3d4206d91bfd0"
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