class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://ghfast.top/https://github.com/aws/s2n-tls/archive/refs/tags/v1.5.25.tar.gz"
  sha256 "ba7d7000a13e109c062e758afa26a6355d7fae3a7279da17e69f0d5a74e438f2"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e02a1abab98384811041bee1bec170f61ebceebd81e24b7d339360ee8b137f67"
    sha256 cellar: :any,                 arm64_sonoma:  "67dc072ee2c9285892c6fdfcc54643e5b362aacab7be9491810b8628b6da522f"
    sha256 cellar: :any,                 arm64_ventura: "ca7cda7300a7d490870b28155f6eb71c2aebf22064d958d04eef1c1c47d150b8"
    sha256 cellar: :any,                 sonoma:        "3088437d359b02e708ee800616ca50573563a014434da5bc13d85b7ac0b14606"
    sha256 cellar: :any,                 ventura:       "79895d490f16127a06ecfad6c30d09c8fb6ce5bbd2773e8057266db28450fd55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "048a4ea4621f333ad6fb1848f237e8df843855d7531e4fd6f348828ac96b1a84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09d6ce18e0d87954ec4bbb904232780948ee51da7bbbce1f8dacd52efb19ed1f"
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