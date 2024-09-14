class Groestlcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https:groestlcoin.orggroestlcoin-core-wallet"
  license "MIT"
  revision 1
  head "https:github.comgroestlcoingroestlcoin.git", branch: "master"

  stable do
    url "https:github.comGroestlcoingroestlcoinreleasesdownloadv27.0groestlcoin-27.0.tar.gz"
    sha256 "cf8de03ef104e67aa7c0c1f69fd78e19ea6fa3e8187d890d7916c1c72a3be530"

    # miniupnpc 2.2.8 compatibility patch
    patch do
      url "https:github.comGroestlcoingroestlcoincommit8acdf66540834b9f9cf28f16d389e8b6a48516d5.patch?full_index=1"
      sha256 "08ddebda702cf654f1b0cef22fb0b71ee2d97d0373e382a6ccf878738aade96a"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "dd2ee1fee9bfc8c3bde45ade57652d3433c701c4b9462783d790c125f7523e89"
    sha256 cellar: :any,                 arm64_sonoma:   "a26c116d48f076dab3cdc4d2306a1dec7dc7acfd3f094b0f4d5fd2e7e45a4e92"
    sha256 cellar: :any,                 arm64_ventura:  "cc1f2364ca6e1301cee3cd9af5be8aff13175a171be85fba6f82443afa93f244"
    sha256 cellar: :any,                 arm64_monterey: "b687ce36c1ffb7951bee1f790b8a43ade4e19a9b03e1f72748a5518510f0537f"
    sha256 cellar: :any,                 sonoma:         "0d10371f28791f79dfe2ce798d079bb476ac5abb3f868b8dff57688e325739ae"
    sha256 cellar: :any,                 ventura:        "37f91f29b4cbcad10c84edbf305af228e2a0fc3a6f564a8f3cf0620369208d86"
    sha256 cellar: :any,                 monterey:       "5f1d9e9d9b8ff30cdf0984abfebe6ce999d8cf14f2b27b7ef0aaf652f7b30da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f9e5dc18d597189cee362ce0e5ea09028e3d463ab17bfe531a24e3136e95c8e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@5"
  depends_on "boost"
  depends_on "libevent"
  depends_on macos: :big_sur
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
    system ".autogen.sh"
    system ".configure", *std_configure_args,
           "--disable-silent-rules",
           "--with-boost-libdir=#{Formula["boost"].opt_lib}"
    system "make", "install"
    pkgshare.install "sharerpcauth"
  end

  service do
    run opt_bin"groestlcoind"
  end

  test do
    system bin"groestlcoin-tx", "-txid", "0100000001000000000000000000000000000000000000000000000000000" \
                                          "0000000000000ffffffff0a510101062f503253482fffffffff0100002cd6" \
                                          "e2150000232103e26025c37d6d0d968c9dabcc53b029926c3a1f9709df97c" \
                                          "11a8be57d3fa0599cac00000000"
  end
end