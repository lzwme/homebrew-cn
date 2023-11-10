class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://ghproxy.com/https://github.com/savoirfairelinux/opendht/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "7b1e451a21a10ac1d189c9467be75e4e3e4e6769ed8cab37a9c7f098b361dd22"
  license "GPL-3.0-or-later"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "39114f04e733a53ef24637248a6e420a3b3d8de4f2f11274b76effc2c9c4920f"
    sha256 cellar: :any,                 arm64_ventura:  "3617bdc64ac45b7d08e144677b04a0a3948f1b4848cd052a827bd3f6be67c250"
    sha256 cellar: :any,                 arm64_monterey: "95274964c0cc8454a068d83a065e719782ac5b9e5aa53a809df2a36daf284470"
    sha256 cellar: :any,                 sonoma:         "593812fee5dc81f8e0ea91e1edd4f6a89c009a64f9d4294577ee74aff67393d3"
    sha256 cellar: :any,                 ventura:        "13face647e37f84b8e4d01653bfbefeeb68fde6df15938d067f3b00e3c318c35"
    sha256 cellar: :any,                 monterey:       "565444c51c941cef5df829f0525b3a35fd8398acd2c3c3bb806ca2d21209e36c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70060d730fbef13025ab070ec939109622e331bd951f22ca740e1cada50b4ea0"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "argon2"
  depends_on "asio"
  depends_on "fmt"
  depends_on "gnutls"
  depends_on "msgpack-cxx"
  depends_on "nettle"
  depends_on "readline"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DOPENDHT_C=ON",
                    "-DOPENDHT_TOOLS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <opendht.h>
      int main() {
        dht::DhtRunner node;

        // Launch a dht node on a new thread, using a
        // generated RSA key pair, and listen on port 4222.
        node.run(4222, dht::crypto::generateIdentity(), true);
        node.join();

        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-lopendht", "-o", "test"
    system "./test"
  end
end