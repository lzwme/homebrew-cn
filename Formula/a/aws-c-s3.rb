class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https:github.comawslabsaws-c-s3"
  url "https:github.comawslabsaws-c-s3archiverefstagsv0.7.5.tar.gz"
  sha256 "d2f68e8a8e9a9e9b16aecd4ae72d78860e3d71d6fe9ccd8f2d50a7ee5faf5619"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cd0c81bcf205e5c07034a11bc38dc02641897d5030ee798ec81518f64685a656"
    sha256 cellar: :any,                 arm64_sonoma:  "e341221205a3533d38fee15ccb1ea8e95bf9408d00a32c4a1b7d36192cd4e340"
    sha256 cellar: :any,                 arm64_ventura: "a0ad20cb56d09cef1794c59e38c3637e90553a5e4f27bd211cec6eb52b3ef7e5"
    sha256 cellar: :any,                 sonoma:        "d8d25ae714c3693de1d8accaedc711f8c072be84547dc18e1fa6764976b6ab62"
    sha256 cellar: :any,                 ventura:       "d9c0000864d5922e2175ac22080e6272e418de044ccd25756126c87fa6623464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d339ecdbe17774dcf552bc5bd412788c221ab3048af2d4fb7c7a6741a40f931"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-auth"
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-checksums"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}cmake
    ]
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