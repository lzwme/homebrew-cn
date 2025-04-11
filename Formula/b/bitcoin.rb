class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https:bitcoincore.org"
  url "https:bitcoincore.orgbinbitcoin-core-28.1bitcoin-28.1.tar.gz"
  sha256 "c5ae2dd041c7f9d9b7c722490ba5a9d624f7e9a089c67090615e1ba4ad0883ba"
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
    sha256 cellar: :any,                 arm64_sequoia: "06006ddd8355af774ec5a8f2353e0caf55a7ca56d353a3f47e33e201e8cf5367"
    sha256 cellar: :any,                 arm64_sonoma:  "c86da89b55363e4172e971d0b42badd7aadf8ea4113f364a0a16fe07b1ad01fb"
    sha256 cellar: :any,                 arm64_ventura: "b955f167908e20578d6c964433c395ad9daee31f248c94165cd029b5a681d990"
    sha256 cellar: :any,                 sonoma:        "e8a97cac935bf909971e2b7fce84c479ee630da0cc2d72444127a83ceac055ec"
    sha256 cellar: :any,                 ventura:       "db32711ae5d7c918368fa0dd422105f7e1c54e7d607c5885b587e2daab7ea274"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b6c930fc44a3df0f510fc5e786371d1b7b304ea434577b913cc0fd2cc5844f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ab7e564dcc037305947232633244012fbe4043e09ab38db130bed6087d72325"
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
        # Fix linking with static libdb
        ENV.append "CFLAGS", "-fPIC" if OS.linux?

        args = ["--disable-replication", "--disable-shared", "--enable-cxx"]
        args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

        # BerkeleyDB requires you to build everything from the build_unix subdirectory
        cd "build_unix" do
          system "..distconfigure", *args, *std_configure_args(prefix: buildpath"bdb")
          system "make", "libdb_cxx-4.8.a", "libdb-4.8.a"
          system "make", "install_lib", "install_include"
        end
      end
    end

    ENV.runtime_cpu_detection
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