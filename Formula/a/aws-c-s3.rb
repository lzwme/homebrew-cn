class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https://github.com/awslabs/aws-c-s3"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-s3/archive/refs/tags/v0.12.6.tar.gz"
  sha256 "d70061a523ee1fb6f0127e52653e7cc252347893295d675797b3d387e0e46049"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "441e31f41e4b85b5fa09bc829b1db9ccefef1f1f2387a5c73619dae61c0950c2"
    sha256 cellar: :any, arm64_sequoia: "07250c4e6b0c67a7a9aefda5dc977753a538ef0f92875c366ab1150a6257b2af"
    sha256 cellar: :any, arm64_sonoma:  "fef59de83a100641bb0bab2ee8443ac5874a5aee74c57c643b9691797d8522bb"
    sha256 cellar: :any, sonoma:        "b7a014d3e9c3f9bca0c3bb362b41bec112caa4aabb53e5fd70434022a4b42133"
    sha256 cellar: :any, arm64_linux:   "0162c89c71965bee639185610158e12ac15479b27245e47a326a24466adebb42"
    sha256 cellar: :any, x86_64_linux:  "5eee8cbc532bb34a03f3e856a93f9f47228146b4d62c88f90253851e94321044"
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