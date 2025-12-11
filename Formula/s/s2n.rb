class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://ghfast.top/https://github.com/aws/s2n-tls/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "84f52b3c841a110931442022d05b53b00353e64b03128dd24006438935e1cc32"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c13da12b87edbcaa6d5d5c9b92c913bbe6297555b0dbcb7fb9cb78aa03f93cd4"
    sha256 cellar: :any,                 arm64_sequoia: "703a0a45cb970e15233bd1508238f6f98bfaead5bef959adf07cc2fb819dc936"
    sha256 cellar: :any,                 arm64_sonoma:  "9052b65b8657702b2ca87d864dd83c08dec201a60ed207c36ba4510ed62bcead"
    sha256 cellar: :any,                 sonoma:        "6466c38d78ea68bf2d57adc701a038d01550133ad719c67e2f5ebb3a80d9f020"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2404be5cb3b0e2223b9c26fa0d4e526159a4f583820e3c18e18c1602175fcc46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e44a20056cdd8fda960b9e0fa14690cc00e3086bb96b359cc2691601863c121"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build_static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build_static"
    system "cmake", "--install", "build_static"

    system "cmake", "-S", ".", "-B", "build_shared", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end