class Groestlcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://www.groestlcoin.org/groestlcoin-core-wallet/"
  url "https://ghfast.top/https://github.com/Groestlcoin/groestlcoin/releases/download/v30.1/groestlcoin-30.1.tar.gz"
  sha256 "8c67fab6a12e5cff8861b9c8be91ea5ca5590de6b92a85508e76098a1964591a"
  license "MIT"
  head "https://github.com/groestlcoin/groestlcoin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b58cf718ca9c862ca893f35a2e50d4df75bd1f25de21d531fa96fd63bbc8f98"
    sha256 cellar: :any,                 arm64_sequoia: "b5e56a4e777e1ae793d6829908fe9e1893c6a04d609ac7966666ffa19a893a67"
    sha256 cellar: :any,                 arm64_sonoma:  "22790c6323df8877b7f8564eabb05d325549bcf778bffb999a90b78adcb96ada"
    sha256 cellar: :any,                 sonoma:        "bcedb81b561bcc3f5dcff2c6ce810be3f5d619830665f6b4f8da6d20baa19b6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc8eb9d459302fb2de79eb8afb3c3bfbeea6f0695549563319f767541e963885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "524d3da763086542e931389fe98082e43f2bd58560f3c5212f71a01154a6675f"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "berkeley-db@5"
  depends_on "capnp"
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
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "share/rpcauth"
  end

  service do
    run opt_bin/"groestlcoind"
  end

  test do
    system bin/"groestlcoin-tx", "-txid", "0100000001000000000000000000000000000000000000000000000000000" \
                                          "0000000000000ffffffff0a510101062f503253482fffffffff0100002cd6" \
                                          "e2150000232103e26025c37d6d0d968c9dabcc53b029926c3a1f9709df97c" \
                                          "11a8be57d3fa0599cac00000000"
  end
end