class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https:github.comawslabsaws-c-s3"
  url "https:github.comawslabsaws-c-s3archiverefstagsv0.7.3.tar.gz"
  sha256 "2818c7594ef7add15381c568729a5ff666367e35ea83fa5f131dc72c0f97dc05"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9f958725f4ff91a595a6b3e8a24eca3b3ae5be1f3f67a05d8569b53e3847d524"
    sha256 cellar: :any,                 arm64_sonoma:  "ee4c600fa736d26cbace44e7b3cbbfeb718750a5c56a2cb13e3f734fcca6a814"
    sha256 cellar: :any,                 arm64_ventura: "94badf28e1c1de9f7ca20c5d7cf6201b12997599a67573278edf0593de67906a"
    sha256 cellar: :any,                 sonoma:        "9d0490bde9aae4f1c3f7fdac83f7946293c3a4ede770bac1f7c71d5dbee5b811"
    sha256 cellar: :any,                 ventura:       "c8d57eb27bc1d7304277520ccb03a47b8a6b376797462c36a0c86faa404cf5e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5adeb3863ae6ee84ed1a9552d97c74ea1ae658434e0ff41bfd1a09f3add82b4"
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