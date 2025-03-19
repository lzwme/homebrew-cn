class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https:github.comawslabsaws-c-auth"
  url "https:github.comawslabsaws-c-autharchiverefstagsv0.8.7.tar.gz"
  sha256 "b961cbed0b82248d3ea7a47f5a49bf174d5a0a977bbdd7ef3e1b2d2eb5468af5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e6b5a3e49178aeac3fcd7abeebf9e2d3eb1d60ba7cd755a3636bf548daa01a58"
    sha256 cellar: :any,                 arm64_sonoma:  "50cd70e04b8dbe6f286e91a6ffa75ed54bd07c507ba0639e72208d826655e486"
    sha256 cellar: :any,                 arm64_ventura: "805c1501e46c0bad8e097d8d139dbd4878a105bb7b3c38d916659f29d1ed8148"
    sha256 cellar: :any,                 sonoma:        "db96b4b72ec2a8231dbcc1c15d7a0743af59697cfbd30b10aea3597a541e3c23"
    sha256 cellar: :any,                 ventura:       "c5a25985534522bfc58c08a90560a608e730c83459124524e25f2f22a9af6c1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "091246d9137af3d583f9c45e1c22f6e16bf68ac15d2d71d8567977b5b0d2c7cb"
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