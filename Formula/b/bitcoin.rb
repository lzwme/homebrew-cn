class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https:bitcoincore.org"
  url "https:bitcoincore.orgbinbitcoin-core-27.1bitcoin-27.1.tar.gz"
  sha256 "0c1051fd921b8fae912f5c2dfd86b085ab45baa05cd7be4585b10b4d1818f3da"
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
    sha256 cellar: :any,                 arm64_sequoia:  "406c2cd86948bf394c4a740d7a731dbdae72cc50bc52d36ca7a758520e238b5a"
    sha256 cellar: :any,                 arm64_sonoma:   "545ca96eca61db3e8ba5abe1c8a21d5ca3895be3c23696037023b8fecfb71431"
    sha256 cellar: :any,                 arm64_ventura:  "74596218beec67cfd41f822c1d27962a9a497031fff5001e600dc4667adf19fd"
    sha256 cellar: :any,                 arm64_monterey: "8154c69f0f380b5ac3d278c84ff890fbf1ff6f849d93ad4395c81385c57b2d9d"
    sha256 cellar: :any,                 sonoma:         "b3eaca532c4eaf757883c785556c2a1f66939d757d56e471a031d934bcb2ae58"
    sha256 cellar: :any,                 ventura:        "adda2c14c11260796f49e28237ed474888c85ab2e7077fa6f1bb912526195a8d"
    sha256 cellar: :any,                 monterey:       "19581b4780b46bfbbc50fb9f33bf3a46a1afbd36e3c1dade5ac11c10a13c5efd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f3434a672c3702b6558c90d74a9b7a4a43bf80a43ad9efb268c7c7b7b1f8c87"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on macos: :big_sur
  depends_on "miniupnpc"
  depends_on "zeromq"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
  end

  fails_with :gcc do
    version "9"
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

  # miniupnpc 2.2.8 compatibility build patch
  patch do
    url "https:github.combitcoinbitcoincommit6338f92260523eaf7cd9c89300f4f088f9319b0d.patch?full_index=1"
    sha256 "3544c7a1ea5c5b4e1c196fbd9fc871800b97728eec893d3980a4488e9fd1e2a8"
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