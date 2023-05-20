class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-24.1/bitcoin-24.1.tar.gz"
  sha256 "8a0a3db3b2d9cc024e897113f70a3a65d8de831c129eb6d1e26ffa65e7bfaf4e"
  license "MIT"
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fe9597e08414649291bc9981933a9723ccc5f847ef2402e7bc87d5a0e05e317b"
    sha256 cellar: :any,                 arm64_monterey: "9d8a78a5ea912fe38370e92ec03726afc69787f9e761a992510ddb6e90f9dad0"
    sha256 cellar: :any,                 arm64_big_sur:  "6624bca94a23c2c628d1ac95962bb08779311816d1215c4830d9d966a96c008f"
    sha256 cellar: :any,                 ventura:        "746922530c8f7077dfd409aa7a33fc6abd6512e1a1119b338f5aa993b6e09a6c"
    sha256 cellar: :any,                 monterey:       "efb9f339d85705c27a44acbe7d88f52172da106eda15c2fc30a6c4bee07b0ed1"
    sha256 cellar: :any,                 big_sur:        "0266dbea8c19ecb558b1d93dc5f3ac1d05e4039a018d23590b78f9f767e78c07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23a4327ac9d3bfc32ea6b68961c29bc1b1aa281084b8e657898cf5313aa4cd78"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  # berkeley db should be kept at version 4
  # https://github.com/bitcoin/bitcoin/blob/master/doc/build-osx.md
  # https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md
  depends_on "berkeley-db@4"
  depends_on "boost"
  depends_on "libevent"
  depends_on macos: :catalina
  depends_on "miniupnpc"
  depends_on "zeromq"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
  end

  fails_with :gcc do
    version "7" # fails with GCC 7.x and earlier
    cause "Requires std::filesystem support"
  end

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}"
    system "make", "install"
    pkgshare.install "share/rpcauth"
  end

  service do
    run opt_bin/"bitcoind"
  end

  test do
    system "#{bin}/test_bitcoin"

    # Test that we're using the right version of `berkeley-db`.
    port = free_port
    bitcoind = spawn bin/"bitcoind", "-regtest", "-rpcport=#{port}", "-listen=0", "-datadir=#{testpath}"
    sleep 15
    # This command will fail if we have too new a version.
    system bin/"bitcoin-cli", "-regtest", "-datadir=#{testpath}", "-rpcport=#{port}",
                              "createwallet", "test-wallet", "false", "false", "", "false", "false"
  ensure
    Process.kill "TERM", bitcoind
  end
end