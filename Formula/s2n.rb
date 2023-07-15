class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://ghproxy.com/https://github.com/aws/s2n-tls/archive/v1.3.47.tar.gz"
  sha256 "72b4b2dc9f8d8c1647738fca631c7a75b4d2d5e461e21961a3727ab8e9bc6ce6"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "86389286180b7a72c72cdd996dcd09d543c4ec81c1952f410959aebbfc871b9d"
    sha256 cellar: :any,                 arm64_monterey: "77629598fa02ed7908d123bc792e53d6d9d34b629e51337d99949cc2e0fea016"
    sha256 cellar: :any,                 arm64_big_sur:  "ec51449bef1b377dcc3658487365e1377fc05addd2aafaac417bdb086ffae1d0"
    sha256 cellar: :any,                 ventura:        "04d47c0594deb8404cf23b02d39aa8e625cda8d638d2ae71bea7c44f6e639876"
    sha256 cellar: :any,                 monterey:       "185b9b3c92ab3b50b85590f88023c5ed1c06fa8efacdd065c3522ab290b6760d"
    sha256 cellar: :any,                 big_sur:        "3f2daa416d64f4f87eaeba7d8c12f5c7f9bffa7f4714e43fc2b5a035ded03c54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cac69e36fe7744a9a23eff726e27726baea69966c6c1285ff9f27aced064ffc5"
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