class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-auth/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "6129719183bb610c84b9e1be445353e9245d1c98d112412ed86bab6890934574"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bf6cf3d05b8ee530eb385417169ee3dbf2e7df53e62ea7038022474805c247bf"
    sha256 cellar: :any,                 arm64_sequoia: "4a7c105844384f1b44f559d6b0af9841d862172b39fac56b03919fc45e876237"
    sha256 cellar: :any,                 arm64_sonoma:  "ccbb1dd80349bf3323a4d9cd7b5d3bcd5019e07771bbdbdc288e45318589bd01"
    sha256 cellar: :any,                 sonoma:        "3603783fa3936239ff0abc0dd53d8b4aeb6b69520c7469faa6ff2e3b43d18378"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fab37128be33c7a67bf3bada28cfce0735292c40c9641f7912df6afc4d89fa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad343a03960cb42591ea17db3c618f22b69145d2b92a38f51a54a8cf1a6e9dad"
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