class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://ghproxy.com/https://github.com/savoirfairelinux/opendht/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "978283d7508f29d03344d942c1cd1fd6a37f27913cb030d2191399c8d79c448b"
  license "GPL-3.0-or-later"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a0da9216ceabfdcd3e37df39ed75ac127f7e36f6c09fe62c76605dc987ef3475"
    sha256 cellar: :any,                 arm64_ventura:  "b73831dc7f5a762cc69633210f25d4f3f0f8034252e7932bc974304038d782cf"
    sha256 cellar: :any,                 arm64_monterey: "05346df38d4ae032c4fc3d84961faba47f462746ff2ce8f32f409280342e25b0"
    sha256 cellar: :any,                 sonoma:         "c87ef1848545879befc1243dfc06ca55d8cdda7f2e920cc937d4fd17b321ac5a"
    sha256 cellar: :any,                 ventura:        "f61b832f59fb7332c93b5e630e1ec405329c4a0edd3eae234b865a6456140816"
    sha256 cellar: :any,                 monterey:       "44b7f5d4936561800b5c4ff0df02612111b3aaa20c36afe052229de81540d09b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83e065861056a382a299e2c6e53737e8aa2806f5c5985d057db9c06b7699ebc7"
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