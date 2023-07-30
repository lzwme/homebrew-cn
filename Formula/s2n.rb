class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://ghproxy.com/https://github.com/aws/s2n-tls/archive/v1.3.48.tar.gz"
  sha256 "26ab869394c6886b64ff57a0974934e51ed9faa963b66149ba90a60adf4651ac"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "be157fd33cbe025017d5c45d26bdb3512ee5e39c3c7c722be062b6e8747ebacd"
    sha256 cellar: :any,                 arm64_monterey: "d523342dc1227ed6048c2911f75d67f785c59b4c92255ace693cef327dedefad"
    sha256 cellar: :any,                 arm64_big_sur:  "234333b5e8312188c7e33ead94b4e818cb6ef13781799b3a4d066bd429b5c67c"
    sha256 cellar: :any,                 ventura:        "9fad7778e17e9c8bb49f8a62ea7e1ad263bb210ef3489dc8415d9ab22e61b33e"
    sha256 cellar: :any,                 monterey:       "5645ef20beb819c9e8d90f22203c5b6b25a64268be087709563cae6422734e3a"
    sha256 cellar: :any,                 big_sur:        "519832617eb08e14a0b6ec44984ea5bad5ce0cce6764a9f568897a0a50a10334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f769d41b23775bfcf4ce0b55b042b7469fa3ba97dbc08ec6a86eae221cbf1185"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build/static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"

    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end