class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-auth/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "832d2ae61ccd408ef001dd14eb909cc9551a5724211a817688bbb898a60457a7"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b49b0450e5cfd7d45cfc7c99c789bcfcece77c628a870ed7ae289002432c6807"
    sha256 cellar: :any,                 arm64_sequoia: "bc07b21fb770258e58e5e298519900edf2704fcd40093ca28465a2bdebac3d18"
    sha256 cellar: :any,                 arm64_sonoma:  "5910c8e65b9977ab4bbf0d57e09406cad59962ba7ccad08b15e2ce13dbfc8732"
    sha256 cellar: :any,                 sonoma:        "d2872c8746cfe85bf01f0c8e0f250610351696438e7c924d2b7a9de66f895f50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0475be5fdce1a65a11491b9a4f22750bf65f05aa36e3690ab1a8950c7f3e0cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc44e214d4b690faef071d1766deed3bf5141a5c0c31f9666ac546335fdc51cf"
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