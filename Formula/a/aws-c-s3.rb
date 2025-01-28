class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https:github.comawslabsaws-c-s3"
  url "https:github.comawslabsaws-c-s3archiverefstagsv0.7.10.tar.gz"
  sha256 "6e3a9d6aab23a85cae11ac3fe35597844a1862a6acd982b6fd0e2a6e7778b754"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "be0e02d1a9fe20fa578ee9981040bcc3e2ce50a0cefcde82d2cd7a8b34ad6364"
    sha256 cellar: :any,                 arm64_sonoma:  "045fa7ef17dc8e237b70ff7019d606c88a6ad58a720bf29b8426e23a339cac28"
    sha256 cellar: :any,                 arm64_ventura: "82e2d369ce0d392e0b26530856695bc28e6be94e13cd7450e1d8c0d90230383f"
    sha256 cellar: :any,                 sonoma:        "4bff3187417e8882fbf80610319314774ce8bed2a47ab685e641e1c177ff4f5d"
    sha256 cellar: :any,                 ventura:       "5824c9f3b38aeb94ad3b0c11e71aa2fb53cdd5503a041df4ed8eb4274d43685a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b480c47e77541089591c862bddce4d3b5970f22dc9a2de718946b8bb99fc3cbd"
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