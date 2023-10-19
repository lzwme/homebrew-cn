class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://ghproxy.com/https://github.com/aws/s2n-tls/archive/v1.3.55.tar.gz"
  sha256 "3b4d51d08326757440a7a134dd4d73c904b700d64837aa7fec0aca908b70fd9b"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3f48b21c403f2531a0d61cc6f7b495a051fbd8557c9e7e5f478daffd4e5db69e"
    sha256 cellar: :any,                 arm64_ventura:  "d59cbb5c85dbdf45dee7edc2cf9f3597daddda8fca3e9f8f0dcfcb2cb436ae70"
    sha256 cellar: :any,                 arm64_monterey: "dda35ecc15b12ee60a434aeb7ddba2583e6127e21748c8dc485e225eb695134f"
    sha256 cellar: :any,                 sonoma:         "b942abc30a17e6f7a42367893b7aab0aa88b48ec52c393cc6b0b0aa52afb6c64"
    sha256 cellar: :any,                 ventura:        "75b4468ecaad060deff0216852d845d6fb87c37cf7054a76315cbfc444432309"
    sha256 cellar: :any,                 monterey:       "d7eca3863c5b067d31da697ce3eac878cb2a5ef6219e6f171b53d556dcaefe63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f0b06a9c569523b401c59fd11a96809a0caefb3968414a1632342dc71294821"
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