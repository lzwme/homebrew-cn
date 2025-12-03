class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-auth/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "e7ad0abad2b2b4211483e6a57cf8ccb9b56b5c6bd10e94864566fd1dcd85dafd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f2e75811881d8b6bc9981a057b8d71a9ac994c24b1cac9ec5c4dea2221e73554"
    sha256 cellar: :any,                 arm64_sequoia: "dbd52226286d1b92cdd252ed36884306a32f50c015961cf8358f6b4f2800a167"
    sha256 cellar: :any,                 arm64_sonoma:  "a18fb907db8d55be10180f51abe5138774ba7000be7df027b21b5c9675cee331"
    sha256 cellar: :any,                 sonoma:        "1051450d4b5a5f01652ac392439edd1c9eba127a9f4177d66a052aa59de39c0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38864634d20a03eb31cd38e761c9d9a99c51fc91a98f9dee5f7818b098a53bf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1a3b611a6687851a11319420bf54f568f0122f669b8ac70728bb49908968592"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-sdkutils"

  def install
    args = ["-DBUILD_SHARED_LIBS=ON"]
    # Avoid linkage to `aws-c-compression`
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/auth/credentials.h>
      #include <aws/common/allocator.h>
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
    system "./test"
  end
end