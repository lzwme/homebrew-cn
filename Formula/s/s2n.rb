class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://ghproxy.com/https://github.com/aws/s2n-tls/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "3f786cb2f35e0551e120e1747e7b510a8228cd852073afa241313939672046cb"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "45c8320e96b0212d12dfae3faa760d36af95869bb2136d54ee9a49a79338fab8"
    sha256 cellar: :any,                 arm64_ventura:  "d925e358a8c06097461e37771fffd24722d1bdf0a749022d988296dba6bb10b1"
    sha256 cellar: :any,                 arm64_monterey: "dfe2dd2d731328e5b02f02b5f4c8ca118daae5b7a13a11446b778e6b95820ffc"
    sha256 cellar: :any,                 sonoma:         "79f9eab17dd8d759a7ceb2414aa03754199e83b4301273b1267881ff5c261c4e"
    sha256 cellar: :any,                 ventura:        "0495488b5b47c49854b35081bd574b0a6d5254687d0b05a103b1c578c400de60"
    sha256 cellar: :any,                 monterey:       "bdd917ce919ec7032eee84dead23148a3cebfd9a97961dfd6f7858e4f3005271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f3391eed297096fd0ea9dc34f06d2ab3e67d74b7debddebc6a09f9fc6336a55"
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