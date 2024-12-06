class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https:github.comcryticechidna"
  url "https:github.comcryticechidnaarchiverefstagsv2.2.5.tar.gz"
  sha256 "148504b6881727265f4fd87c699cf521b0cb8bb7b0dea4cba42b97e2d588ec16"
  license "AGPL-3.0-only"
  revision 1
  head "https:github.comcryticechidna.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "15434151c4692b9edb45d66c0ea7924edc304e20ebf9fa37400874fcc089e8fd"
    sha256 cellar: :any,                 arm64_sonoma:  "ac97f82cfe20ee7565794496ac1e129d9d119fd3f00366e98ea27d0da838e716"
    sha256 cellar: :any,                 arm64_ventura: "f081bc8f4e357a66b581cc8b1977f25431e03e1de544313cbe622f946dba9a19"
    sha256 cellar: :any,                 sonoma:        "6ba066a900d1d2d64e25e19db0115f2187106bbf16d1bb0f929034f2b4d14a2d"
    sha256 cellar: :any,                 ventura:       "e6a88f34daca135244362e116d954ee333e036b621656e70dfc4db2b4aa943cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca3e2796402ea85f7f013c4cd11827e6f65b462247df88ba8c6ad08c3f510f0c"
  end

  depends_on "ghc@9.6" => :build
  depends_on "haskell-stack" => :build

  depends_on "truffle" => :test

  depends_on "crytic-compile"
  depends_on "gmp"
  depends_on "libff"
  depends_on "secp256k1"
  depends_on "slither-analyzer"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    ENV.cxx11

    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    ENV.deparallelize

    ghc_args = [
      "--system-ghc",
      "--no-install-ghc",
      "--skip-ghc-check",
      "--extra-include-dirs=#{Formula["libff"].include}",
      "--extra-lib-dirs=#{Formula["libff"].lib}",
      "--extra-include-dirs=#{Formula["secp256k1"].include}",
      "--extra-lib-dirs=#{Formula["secp256k1"].lib}",
      "--flag=echidna:-static",
    ]

    system "stack", "-j#{jobs}", "build", *ghc_args
    system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install", *ghc_args
  end

  test do
    system "truffle", "init"

    # echidna does not appear to work with 'shanghai' EVM targets yet, which became the
    # default in solc 0.8.20  truffle 5.9.1
    # Use an explicit 'paris' EVM target meanwhile, which was the previous default
    inreplace "truffle-config.js", %r{\s*evmVersion:.*$}, "evmVersion: 'paris'"

    (testpath"contractstest.sol").write <<~SOLIDITY
      pragma solidity ^0.8.0;
      contract True {
        function f() public returns (bool) {
          return(false);
        }
        function echidna_true() public returns (bool) {
          return(true);
        }
      }
    SOLIDITY

    assert_match("echidna_true: passing",
                 shell_output("#{bin}echidna --format text --contract True #{testpath}"))
  end
end