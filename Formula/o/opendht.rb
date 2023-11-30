class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://ghproxy.com/https://github.com/savoirfairelinux/opendht/archive/refs/tags/v3.1.3.tar.gz"
  sha256 "4dacaac70104e6b0b10e0716eba24691b65f5aa47660b6b93dde778378505b59"
  license "GPL-3.0-or-later"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3bfc3db2c3f9ac898be4b2e3537f6a8fe755f86c06d5b5a042c9ed8a4b3b54f0"
    sha256 cellar: :any,                 arm64_ventura:  "cc12b023f7384e0e82d7c7bc4864271d3ce29619572ed751b0e7f1db68a56aad"
    sha256 cellar: :any,                 arm64_monterey: "2e22097bbdeb21e4be885b7a0ea4a3a2c45b6b3cd9cec9f3a32534eaf8e984c3"
    sha256 cellar: :any,                 sonoma:         "d6f0e2484072f940407cd33720adb522dbe8b034f80df36fc88ce9cb21915e54"
    sha256 cellar: :any,                 ventura:        "f03a66ffc7f8dc194e0a4f99508feeaa129c0b531f5e6975ccf4131f67e5979b"
    sha256 cellar: :any,                 monterey:       "14f70e0bec74bbd9fa7e44ead0a1a2c7467a5f0d7e9741a58139341034ec72ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39fdfa1186cb781e49b6aa5ee8c833b817fb7853c002663cda5f913fa500fd0d"
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