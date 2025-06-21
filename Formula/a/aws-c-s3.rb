class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https:github.comawslabsaws-c-s3"
  url "https:github.comawslabsaws-c-s3archiverefstagsv0.8.2.tar.gz"
  sha256 "7c8d8a36ce209114282bbdd7997b64f04b5be7f0614cdebc5bf6a31c665ab6ee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8c70d18dea9f640a7165cab36758c0c20a5a21923a037b872e406d78733226fc"
    sha256 cellar: :any,                 arm64_sonoma:  "5e2cd0f7787e7fd1eb1fedfadfecc607065174de30c4c46defdd6e5dd7fc802c"
    sha256 cellar: :any,                 arm64_ventura: "615a7d179013cfbdfa1d79d0c2b0d1002c7c607be16717df5a50b8c33105802c"
    sha256 cellar: :any,                 sonoma:        "dbd83740dbedb53ef7f90680d0270b39572f984291a4a78e1ad74f74729130e8"
    sha256 cellar: :any,                 ventura:       "1be7304e3cef8ff634fec1e1e8a9dc2dd3886e3cf9324422faa70d2d8b728f21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bdbf3170f36d8bf0f5ee4485b3e88c36269123af61b2673d448c86475cb5460"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80747dd11bf4db1f0d003872d55757ee6eb8b4d81630b589aaa12a3a613c0169"
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