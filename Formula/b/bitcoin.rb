class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https:bitcoincore.org"
  url "https:bitcoincore.orgbinbitcoin-core-28.0bitcoin-28.0.tar.gz"
  sha256 "700ae2d1e204602eb07f2779a6e6669893bc96c0dca290593f80ff8e102ff37f"
  license all_of: [
    "MIT",
    "BSD-3-Clause", # srccrc32c, srcleveldb
    "BSL-1.0", # srctinyformat.h
    "Sleepycat", # resource("bdb")
  ]
  revision 1
  head "https:github.combitcoinbitcoin.git", branch: "master"

  livecheck do
    url "https:bitcoincore.orgendownload"
    regex(latest version.*?v?(\d+(?:\.\d+)+)i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "25bc41954442f22485590732ca3d73368b2dc8b512ded096f1072e118e97cef1"
    sha256 cellar: :any,                 arm64_sonoma:  "9118b0e82481236c3ff7f57bf80aaef4a41939d798df28e685aa7139aeec4356"
    sha256 cellar: :any,                 arm64_ventura: "155d1a175a9d72dd5cfb88cae94fcaa05cddc7ead46044576e084f5c1c4d1bbe"
    sha256 cellar: :any,                 sonoma:        "888b0308b358613cc6ab1ac905a2ba19e8d6692ecc0e4b902110d9e7bf74c7cc"
    sha256 cellar: :any,                 ventura:       "b761c3af4225787ee7cf57ecfbf3c47bff7b897885420ce84b0f038fd4286645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "309692275f6ec837a1d9b8bb58cad44068d0b256affef5b301fd239ed0e64e2e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on macos: :big_sur
  depends_on "miniupnpc"
  depends_on "zeromq"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
  end

  fails_with :gcc do
    version "10"
    cause "Requires C++ 20"
  end

  # berkeley db should be kept at version 4
  # https:github.combitcoinbitcoinblobmasterdocbuild-osx.md
  # https:github.combitcoinbitcoinblobmasterdocbuild-unix.md
  resource "bdb" do
    url "https:download.oracle.comberkeley-dbdb-4.8.30.NC.tar.gz"
    sha256 "12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef"

    # Fix build with recent clang
    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patches4c55b1berkeley-db%404clang.diff"
      sha256 "86111b0965762f2c2611b302e4a95ac8df46ad24925bbb95a1961542a1542e40"
    end
    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
      directory "dist"
    end
  end

  # Skip two tests that currently fail in the brew CI
  patch do
    url "https:github.comfanquakebitcoincommit9b03fb7603709395faaf0fac409465660bbd7d81.patch?full_index=1"
    sha256 "1d56308672024260e127fbb77f630b54a0509c145e397ff708956188c96bbfb3"
  end

  def install
    # https:github.combitcoinbitcoinblobmasterdocbuild-unix.md#berkeley-db
    # https:github.combitcoinbitcoinblobmasterdependspackagesbdb.mk
    resource("bdb").stage do
      with_env(CFLAGS: ENV.cflags) do
        # Fix compile with newer Clang
        ENV.append "CFLAGS", "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200
        # BerkeleyDB requires you to build everything from the build_unix subdirectory
        cd "build_unix" do
          system "..distconfigure", "--disable-replication",
                                      "--disable-shared",
                                      "--enable-cxx",
                                      *std_configure_args(prefix: buildpath"bdb")
          system "make", "libdb_cxx-4.8.a", "libdb-4.8.a"
          system "make", "install_lib", "install_include"
        end
      end
    end

    system ".autogen.sh"
    system ".configure", "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "BDB_LIBS=-L#{buildpath}bdblib -ldb_cxx-4.8",
                          "BDB_CFLAGS=-I#{buildpath}bdbinclude",
                          *std_configure_args
    system "make", "install"
    pkgshare.install "sharerpcauth"
  end

  service do
    run opt_bin"bitcoind"
  end

  test do
    system bin"test_bitcoin"

    # Test that we're using the right version of `berkeley-db`.
    port = free_port
    bitcoind = spawn bin"bitcoind", "-regtest", "-rpcport=#{port}", "-listen=0", "-datadir=#{testpath}",
                                     "-deprecatedrpc=create_bdb"
    sleep 15
    # This command will fail if we have too new a version.
    system bin"bitcoin-cli", "-regtest", "-datadir=#{testpath}", "-rpcport=#{port}",
                              "createwallet", "test-wallet", "false", "false", "", "false", "false"
  ensure
    Process.kill "TERM", bitcoind
  end
end