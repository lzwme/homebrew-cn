class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https:github.comawslabsaws-c-s3"
  url "https:github.comawslabsaws-c-s3archiverefstagsv0.7.17.tar.gz"
  sha256 "cad16b82f628ae05a2bf072de19cad12f69dddcf7817b55eb00037628011fa92"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7316d60df60271303fad215b1fd90116953d0d9f493caa8a50abdd80060f1e83"
    sha256 cellar: :any,                 arm64_sonoma:  "1748673a2ca79677f9759858b04ffbcab5bd7f14575a3164fa1ab1fbfd447f87"
    sha256 cellar: :any,                 arm64_ventura: "73187a2f80cfdbaa49e9375de756b9d54833673b9730e93d8c44a0653416e47d"
    sha256 cellar: :any,                 sonoma:        "1a56b3d0b970c23da060cce7d78f15b83fb13b4ecaa2f743de93314b7968e336"
    sha256 cellar: :any,                 ventura:       "d1b5e44e70e2b454f1f7d917452c917c86b7f77c4e136d9deacc50ccc728927a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "503137b353806683cc5c931d7df9970a4d8baa4c9a989fd86943ea2ca2d59199"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c63e27e3de9bdbc9a43ba8b3a275121bd6fd8704a612f318f0acb8f06e8a1680"
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