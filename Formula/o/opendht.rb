class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://ghproxy.com/https://github.com/savoirfairelinux/opendht/archive/refs/tags/v2.6.0.4.tar.gz"
  sha256 "7afbe6bba1df0ee8a35f6c29a9d250de03555c39aa6c94152f1e34e9abcb6488"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c8d8d4225004bd9f4bf676fcbfdfbdd56c042300bc94f449ede37c530bbe9439"
    sha256 cellar: :any,                 arm64_monterey: "b35fd17e7283850e6d97bdc1c953e4357316a0733b0df47f6b85e8f004a5e0f4"
    sha256 cellar: :any,                 arm64_big_sur:  "fa98cc972c8c5aeee44884a2c41c3941b5451f1b7a288b9bc643f016682153dd"
    sha256 cellar: :any,                 ventura:        "50c0bf994e9b7796526e26bfaa5d00d21a5e7cfa9f0619f2baf71d169b135df8"
    sha256 cellar: :any,                 monterey:       "085887c7d27924ea3e68a599c81e11f147f3bcfbd799829fd16da576941891f9"
    sha256 cellar: :any,                 big_sur:        "f6e2cab6d21e944fac00e39786807fb6eeab32009990ec2da0eae65e79faa476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3a0d7d45a2acd10f24be125b1b14d8be120670d296dfb79e53493f0328f8a2f"
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