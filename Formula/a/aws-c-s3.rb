class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https:github.comawslabsaws-c-s3"
  url "https:github.comawslabsaws-c-s3archiverefstagsv0.7.18.tar.gz"
  sha256 "89cf4a4906ebfd761c85acd161664c5cc640606a90daf8f06f681d4d939454fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "64590908af6def4cbf06a5c3ad0cdccbc3bd25ea8f7630492268e70b9bd53527"
    sha256 cellar: :any,                 arm64_sonoma:  "0114a8034444ea1b6215fcf3f1ed71a1674a98481013ce0ed786bc3e687a3fe7"
    sha256 cellar: :any,                 arm64_ventura: "90d58e0e9bfb36c75a00f41e579ea3a474c7d5dba4445261472ed86c16ad3d5f"
    sha256 cellar: :any,                 sonoma:        "b430b587aef555d2347817995a4ae2b54bf849d6e6c2f78f559ec516cdf6b6f5"
    sha256 cellar: :any,                 ventura:       "3da375777698b64bb3a9810e5922d86affda4b43d4a80baa0f7059f72a56fb49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdb2667ffcc1f926644fb66dc3214137d4ae196cd4eac6cc4218029990fb7fa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f55da7ebe36fc95007339f8ecbb38f3dc32bc73dd3f4bcfc66a376bf4d57aa6"
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
    (testpath"test.c").write <<~C
      #include <awscommonallocator.h>
      #include <awscommonerror.h>
      #include <awss3s3.h>
      #include <awss3s3_client.h>
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
    system ".test"
  end
end