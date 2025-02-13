class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https:github.comawslabsaws-c-auth"
  url "https:github.comawslabsaws-c-autharchiverefstagsv0.8.5.tar.gz"
  sha256 "302f40c189456defe14860d13a22a6bf435cdb9eee2b60c585e8725825385cbb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "340a056340f438475072ef1c97ae8e6864d233928629235a2703306c70381bb7"
    sha256 cellar: :any,                 arm64_sonoma:  "8336d01289362a0177aa892ae261cadb06e80c41ecb4c78732890cf76282e52e"
    sha256 cellar: :any,                 arm64_ventura: "1946ed63930030d2bad4c7164827987db66a4bb0a04b25369f9ba8d62e670a60"
    sha256 cellar: :any,                 sonoma:        "2651881e171063b43ff8d5f28442d546eb638363ba3a33a3f088d9ef5547f25d"
    sha256 cellar: :any,                 ventura:       "4779dc493b812c7e14147ed8c096678cdbde82045a792eb1e89ec4de58604521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54c273d91f2859cce2484c04b1c70eb6376cca7b86d63d6ed05c3f66d8376cb3"
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