class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-25.1/bitcoin-25.1.tar.gz"
  sha256 "bec2a598d8dfa8c2365b77f13012a733ec84b8c30386343b7ac1996e901198c9"
  license "MIT"
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8e1553d204b4dacc3d4ca9d47bc22f767f204eed2101394c598515b0959d5d2b"
    sha256 cellar: :any,                 arm64_ventura:  "b84735f2deea9d76f0baf7e3e431c1946453774329d1d38e0e5d95ad89e5235d"
    sha256 cellar: :any,                 arm64_monterey: "1be587ef78942cd1631d7fc56ca75bc9f6a4f04f88423cd6a7672f9d334b8f0d"
    sha256 cellar: :any,                 sonoma:         "87a46850cfe4942d3f564bb01be5d48c911d0c25921bd4f75e0f4b1842f45c00"
    sha256 cellar: :any,                 ventura:        "754d5abddf7fb242e9316e5fb68fec66b7e614b83101e6e8c7777bee33996dc8"
    sha256 cellar: :any,                 monterey:       "a4eb426b91914aabe88449a369d9e6447241095e2e5cf89b5b9aae2cef5a4fb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9a3f3f799e84c2fe9176dad970298b8760934b911a2e0266528418f8c8028ff"
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