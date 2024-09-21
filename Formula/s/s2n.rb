class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.5.3.tar.gz"
  sha256 "609d4ab5747e592a8749f2db7ff6422ea2e0aff3d2790b6d36defe276f422a71"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "acf5a6837da76aa54f0aa25aaee4e5678f6aacdcb892c91548f70b800f299f98"
    sha256 cellar: :any,                 arm64_sonoma:  "3a46cd4cb9bded85b8d564a4e40c98acb368672487d215a06ee5b4b3fb65ece0"
    sha256 cellar: :any,                 arm64_ventura: "ef13fd87e0008fcb962b8a4feb475cca3da3e5a045c007d02b15af42f156c3ad"
    sha256 cellar: :any,                 sonoma:        "148b6b32d55d31ed2c53a4a9c4fb9e191e584f32f90e8ed352ead7a2151c92e9"
    sha256 cellar: :any,                 ventura:       "9e70be9a1400fdb920d01cd60b1373e23f8279620f8f6111bcf119d57cdc35a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "291bdffb57baabd29b16b75b7cd1026b25a3e646b90fd9b3d8b8badef12f9faf"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  conflicts_with "aws-sdk-cpp", because: "both install s2nunstablecrl.h"

  def install
    system "cmake", "-S", ".", "-B", "buildstatic", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "buildstatic"
    system "cmake", "--install", "buildstatic"

    system "cmake", "-S", ".", "-B", "buildshared", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "buildshared"
    system "cmake", "--install", "buildshared"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system ".test"
  end
end