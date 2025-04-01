class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https:github.comawslabsaws-c-s3"
  url "https:github.comawslabsaws-c-s3archiverefstagsv0.7.14.tar.gz"
  sha256 "1a8cd98612f5d08ac12f1c0ab7235e1750faf8fb0e7680662101626b81963a66"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a72dc602f6a196a371cf3d260c2acb0f962f0980dbc8bb4c3ef33da44791ae52"
    sha256 cellar: :any,                 arm64_sonoma:  "c8abb384f543d27b4330b39472bd6bb325f22a7d1edbc139aef85cf4c90c30aa"
    sha256 cellar: :any,                 arm64_ventura: "a1d847266a1b7b6cbff4a37dfcb5efb7d8a5279ad448ddf344a5efef450c1667"
    sha256 cellar: :any,                 sonoma:        "89e6e507a8c919c1db3000f314451d6c3fe51c83c4c269fcc88f2a2e56919db2"
    sha256 cellar: :any,                 ventura:       "ea35568cc2dc1f82f378ab8c01dcfb501db697b98fe090e04d6c6f72ea3897ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3abf4ea7be690e44e067c485e4205d172359af2398a917380f8be6f6cff3f55"
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