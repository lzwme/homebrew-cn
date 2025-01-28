class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https:github.comawslabsaws-c-auth"
  url "https:github.comawslabsaws-c-autharchiverefstagsv0.8.3.tar.gz"
  sha256 "369c9b21c2f54fd77d61d2a72ba79e208e24736466ab7f21a140937dc7e9c615"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0b2c0752d5422e3e93700ccddaf38e8edd1625f02ce8b6c1e5e7fbf449cb9c19"
    sha256 cellar: :any,                 arm64_sonoma:  "75df66fa7fc01a1be0977fbdd63c32d4a4fa93ea14e2e86b9ba1ad3f87eeb48b"
    sha256 cellar: :any,                 arm64_ventura: "ea2520a3cfa88c65344047bb18c8807c398a94e1e34b08ec60e22ce53d8a9c17"
    sha256 cellar: :any,                 sonoma:        "8ab4c5434457919e633da2314a678f8e656e53401add5c7ff579803eb3216cc5"
    sha256 cellar: :any,                 ventura:       "ee575ddf7d2ae633c80d00b9b90dac038352ac4b66fdc3dd9ee29fb6ef7fc045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "258f964fde6f494cc47237f4e81c69db5e4fb4159347efc7b63e4dc08b5346aa"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-sdkutils"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}cmake
    ]
    # Avoid linkage to `aws-c-compression`
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <awsauthcredentials.h>
      #include <awscommonallocator.h>
      #include <assert.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        struct aws_credentials *credentials = aws_credentials_new_anonymous(allocator);

        assert(NULL != credentials);
        assert(aws_credentials_is_anonymous(credentials));
        assert(NULL == aws_credentials_get_access_key_id(credentials).ptr);
        assert(NULL == aws_credentials_get_secret_access_key(credentials).ptr);
        assert(NULL == aws_credentials_get_session_token(credentials).ptr);

        aws_credentials_release(credentials);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-auth",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system ".test"
  end
end