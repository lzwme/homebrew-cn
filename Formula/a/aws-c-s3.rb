class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https:github.comawslabsaws-c-s3"
  url "https:github.comawslabsaws-c-s3archiverefstagsv0.8.1.tar.gz"
  sha256 "c8b09780691d2b94e50d101c68f01fa2d1c3debb0ff3aed313d93f0d3c9af663"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "99b9f280005c8e44a685a7959490510d124fbcfcc522cae2ec1e313793a20a13"
    sha256 cellar: :any,                 arm64_sonoma:  "fd115e161c4589c38b0424d732a4d0bdedc76419fd330dc2ed72ff9653b3cb93"
    sha256 cellar: :any,                 arm64_ventura: "99f2ac9243891c2db972afc1c16a7060ebb13ced2329c6ab6618b182bc427b8c"
    sha256 cellar: :any,                 sonoma:        "a94ef5a343b458955f10e13ec66cfcbfdfb609bbfb471686f681e0102a838221"
    sha256 cellar: :any,                 ventura:       "911810f1af9a6c287ddfb3207b0fd2bbf9662891b781c40c1df0005092cb8bd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b6238293d9432e2dd2a40741cce2156e3e003a26141db6120048eb153a6dcdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "461df7bccc8c250ea12cabb160a56c842c5d0706d3ee1af386700bd36c03f55c"
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