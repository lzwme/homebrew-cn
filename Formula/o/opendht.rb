class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://ghproxy.com/https://github.com/savoirfairelinux/opendht/archive/refs/tags/v3.1.4.tar.gz"
  sha256 "ab71bd21759d586be1d8f0f405b3aaa3723c48d75a754a6e7339465aeeb24f88"
  license "GPL-3.0-or-later"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a0b610ec2be7ffc2c81ab45ae29c2ebe50fe261989c882e2e6ef83c896841edc"
    sha256 cellar: :any,                 arm64_ventura:  "e9828de5581d4211804c43a864be220b998b1e41d4c76b1f0ae37f5a834738f6"
    sha256 cellar: :any,                 arm64_monterey: "b3d3cb8380e4fa7e23e5f784f62c831ce3e5eff934fa65842de115a071d61122"
    sha256 cellar: :any,                 sonoma:         "474b873b0a728c6736ef530bcea4646048be4916766699031a3955209123b4f8"
    sha256 cellar: :any,                 ventura:        "b83eb05cc0eea2aca22c6488b34b7d86f3b4a599f34eca0c18345906dadc4972"
    sha256 cellar: :any,                 monterey:       "65b5dd8f952670213fc6c3479c464af30398aa4bd6b8a1e43aa3e2d871ee8f25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "add8d87f2410cd7c6ad7f9d7be8a48f63ca1c93879fe9e1ead9d8088f9988ac7"
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