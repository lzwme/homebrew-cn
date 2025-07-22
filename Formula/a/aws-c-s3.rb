class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https://github.com/awslabs/aws-c-s3"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-s3/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "583fb207c20a2e68a8e2990d62668b96c9662cf864f7c13c87d9ede09d61f8e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "84c5b3a015a67f3315bcfb54df2a409d97e2daad8d1e17492d49a493b4af9213"
    sha256 cellar: :any,                 arm64_sonoma:  "57135b1b3c86e512c9216a678b5fcbfd84998a844dc6fd1e8312f76284fdf571"
    sha256 cellar: :any,                 arm64_ventura: "319658c74e4448cbb57c57e5a266ab93e0b94d102d073758e36b321a35e16e22"
    sha256 cellar: :any,                 sonoma:        "388dff9330f02eb3db5f90db5ddf1ca541c05f8d53fc3c715c438a6e900ff00c"
    sha256 cellar: :any,                 ventura:       "e2ac8dfbd0f0e7e5cb5568b0662b6bc92c877e9ff70f3b2a1040ef45a8782cac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bec1ee551df02999d70717fbe8a891f45df2db005ada09aea9b289356c9c0e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24cefa2d3112e1cab68688b7af4ab96cf2916a5c10528e1041e5167de829ae3e"
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