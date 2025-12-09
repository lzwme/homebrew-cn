class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-auth/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "704b2f965c31d9d0fd8d9ab207bc8c838e3683c56bd8407e472bbc8fa9f9a209"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "54ea60f778bc55976b5a0c790301484fe127620b7ed055c58f7447c260476cd2"
    sha256 cellar: :any,                 arm64_sequoia: "861a7dad4d96c6ad9a716f06aa54cb69af3e0b8aa02b535d4434bf4216b8c835"
    sha256 cellar: :any,                 arm64_sonoma:  "9b5ff8bddf3192ed09af177e71ee7f076952d175c81e18499c21de985f13493a"
    sha256 cellar: :any,                 sonoma:        "6260325d1ce3f132eb029a448629dd3502c69f79e57f7111d5dd47a9ddc4e700"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea46e2d43c2fa4b06dba6e30fdd4304539a40a844f20ad8530b4de457e1dc424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a18b4f38be1847508ae4a8e8c8f501e2670a94baf705affc5c505bd793dfb74"
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