class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https://github.com/awslabs/aws-c-s3"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-s3/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "852c0614936d54f77b40f5a0850b4c16a339dc21764006075a6ccb36d90f70ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c9bca37ab4793be2618723ef29b05b93bcc64c3818ab4ec8314ca932896a85f8"
    sha256 cellar: :any,                 arm64_sonoma:  "fb76ef25f0371a61185b615756c6ffbb189f5fbecded01953a9098c4a339284d"
    sha256 cellar: :any,                 arm64_ventura: "544b0715460004ffbc18b45730a0a8809a353c62aebf5f2a6768e45df26e3a7e"
    sha256 cellar: :any,                 sonoma:        "2a3b515c8d44c909ef774f9f22aeadc9b5588ccee52adb88829d6c2182747e13"
    sha256 cellar: :any,                 ventura:       "0d5bc24e6fab9a1a03d7168223446237392267393b278ae447109db3cdfe6b8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "691c9f2a13b35301f311b6a3dde63338d364162febf69423e1bdb3f4a74ab117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b425d090ca48e96dbbcf31bf6db686d584b4907fbbcdc7cb20810034136749f"
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