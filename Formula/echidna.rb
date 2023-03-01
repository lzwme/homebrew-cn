class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://github.com/crytic/echidna"
  url "https://ghproxy.com/https://github.com/crytic/echidna/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "711672269d93e024313cc74c16f0c33f45b432e71a9087ef9e65d5ac0440968e"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "22e0fdba14807b7082ad3dd6fc6fdbed68970b847c5f003a1a60c06fca3c7d27"
    sha256 cellar: :any,                 arm64_big_sur:  "0be421a12ce86be7636cba0b5a245a353526b0970eb1fe1ee49006c6f313735f"
    sha256 cellar: :any,                 ventura:        "3b26fbc32bf5540014e482712e001d038b4d3420cfb6b3a21fabb283f15da6a6"
    sha256 cellar: :any,                 monterey:       "49c5d59d75c29b54a38e730517faa0436bc2f5e49807ec225fe4f0c4cfc0ad10"
    sha256 cellar: :any,                 big_sur:        "bcc1e052340a4009539a54f1ba302fbcbd3e8ed3780866e9e4fd8cd4ec8b3402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b3d9b40e7b1aadd4787cd06b97f46eda3c8a37b4b1c961dd09aaed72921d1f0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "ghc@9.2" => :build
  depends_on "haskell-stack" => :build
  depends_on "libtool" => :build

  depends_on "crytic-compile"
  depends_on "libff"
  depends_on "slither-analyzer"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "secp256k1" do
    # this is the revision used to build upstream, see echidna/.github/scripts/install-libsecp256k1.sh
    url "https://ghproxy.com/https://github.com/bitcoin-core/secp256k1/archive/1086fda4c1975d0cad8d3cad96794a64ec12dca4.tar.gz"
    sha256 "ce97b9ff2c7add56ce9d165f05d24517faf73d17bd68a12459a32f84310af04f"
  end

  def install
    ENV.cxx11

    resource("secp256k1").stage do
      system "./autogen.sh"
      system "./configure", *std_configure_args,
                            "--disable-silent-rules",
                            "--prefix=#{libexec}",
                            "--libdir=#{libexec}/lib",
                            "--enable-module-recovery",
                            "--with-bignum=no",
                            "--with-pic"
      system "make", "install"
    end

    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    ENV.deparallelize

    ghc_args = [
      "--system-ghc",
      "--no-install-ghc",
      "--skip-ghc-check",
      "--extra-include-dirs=#{Formula["libff"].include}",
      "--extra-lib-dirs=#{Formula["libff"].lib}",
      "--extra-include-dirs=#{libexec}/include",
      "--extra-lib-dirs=#{libexec}/lib",
      "--ghc-options=-optl-Wl,-rpath,#{libexec}/lib",
      "--flag=echidna:-static",
    ]

    system "stack", "-j#{jobs}", "build", *ghc_args
    system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install", *ghc_args
  end

  test do
    system "solc-select", "install", "0.7.0"

    (testpath/"test.sol").write <<~EOS
      contract True {
        function f() public returns (bool) {
          return(false);
        }
        function echidna_true() public returns (bool) {
          return(true);
        }
      }
    EOS

    with_env(SOLC_VERSION: "0.7.0") do
      assert_match(/echidna_true:(\s+)passed!/,
                   shell_output("#{bin}/echidna-test --format text #{testpath}/test.sol"))
    end
  end
end