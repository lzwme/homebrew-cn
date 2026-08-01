class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https://github.com/awslabs/aws-c-s3"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-s3/archive/refs/tags/v0.13.4.tar.gz"
  sha256 "66acd3bf25bed7009165511bc335f8cf0ab25ad92e6d228c06cf86fee3cd74c4"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a9272ee21ba32b79d327f2a04d1885803febad6831dbb6d4b33f779d8ff2e5cb"
    sha256 cellar: :any, arm64_sequoia: "afc4f546bda8a45e9497400d7ccb3c26f714af55b2cc2c3da01ad7d139ef0485"
    sha256 cellar: :any, arm64_sonoma:  "c9b65e98e58436b21ed727ddbb71923c0ec73bcf0e52decefad6a719fc7c5772"
    sha256 cellar: :any, sonoma:        "a070b7e3ab6531577938803c5af51059af6ee375a9780bb0d021e11aeba178bd"
    sha256 cellar: :any, arm64_linux:   "a4e3b2e02c46a5d17e0ed84f8033fd81dfee53e9872e5d942eae2a7779326d92"
    sha256 cellar: :any, x86_64_linux:  "2f7366cce07ba0d293eeb0b3d64f3cfcfb1ef0131c6ee26ac5308d88be41cd8e"
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