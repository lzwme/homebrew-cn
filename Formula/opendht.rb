class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://ghproxy.com/https://github.com/savoirfairelinux/opendht/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "519245ad7ceff35f9e45035301b34f8ccafad16c605149b034cc10fd92adb32c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f9688e5da1e2a585879ab77cd44a964aedb497f1bd379d95a9ee1181948e0945"
    sha256 cellar: :any,                 arm64_monterey: "eda6538b97a2723953e8f7b3dbe714a30cdad4b00203a7f33eb0abb909356ee8"
    sha256 cellar: :any,                 arm64_big_sur:  "e4cf7a1038905892568920399e5ba9037ac500976195749938c5dd9d0e9b5506"
    sha256 cellar: :any,                 ventura:        "e4878d5348c3e75182b29759ca536ad90bb52db45d19e51edf783f01b1c44379"
    sha256 cellar: :any,                 monterey:       "f83cdfa2cef31206b10bb3b2f27e381ac7883700a55773916a985a5e3284fecc"
    sha256 cellar: :any,                 big_sur:        "26cd03cf1c4ceab5c065a4533d59091d9af0f9ca97dc3ca601e1ff374e65838f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de7a538e1da76b62731cc5d87e3e5ad0ae3be3b029dae1ec547d063b6fc40c1c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "argon2"
  depends_on "asio"
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