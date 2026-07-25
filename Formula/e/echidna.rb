class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://secure-contracts.com/program-analysis/echidna/index.html"
  url "https://ghfast.top/https://github.com/crytic/echidna/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "c35a6f65c8758743253e91d5ce25017d0d69864f3fad58c41269e9ef4089c1a1"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "374f8e5eae224f8f9bc5aface602f95aaea42a3d5d38cec42c18f56197eb12d3"
    sha256 cellar: :any, arm64_sequoia: "e750db0db4f603c8e7a0960f08e4e6a864cdcafd5cf874fa0899205e347063af"
    sha256 cellar: :any, arm64_sonoma:  "4e177b8785e8a843931a1dd24f72854ade77fec2769fc87f696c5aabb9ca026d"
    sha256 cellar: :any, sonoma:        "7fcef376fbcbf09178bae237d26101867cd895b03515d423a7467053a99ebf1d"
    sha256 cellar: :any, arm64_linux:   "6891e4886b21bd3fde94c41e164606e87cc5680affb825fa2d60ffc3c87c97a7"
    sha256 cellar: :any, x86_64_linux:  "e4e08ce4344e7610cd437780353dba3b0e268ba999f8d22657de6016ae91340a"
  end

  depends_on "ghc@9.10" => :build
  depends_on "haskell-stack" => :build
  depends_on "pkgconf" => :build
  depends_on "solidity" => :test

  depends_on "crytic-compile"
  depends_on "gmp"
  depends_on "libff"
  depends_on "libyaml"
  depends_on "secp256k1"
  depends_on "slither-analyzer"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.cxx11

    args = %W[
      --extra-include-dirs=#{Formula["libff"].include}
      --extra-include-dirs=#{Formula["secp256k1"].include}
      --extra-lib-dirs=#{Formula["libff"].lib}
      --extra-lib-dirs=#{Formula["secp256k1"].lib}
      --flag=echidna:-static
      --flag=libyaml:system-libyaml
      --jobs=#{ENV.make_jobs}
      --local-bin-path=#{bin}
      --no-install-ghc
      --skip-ghc-check
      --system-ghc
    ]
    if OS.linux?
      args << "--ghc-options=-pie"

      # Using global configuration to apply options to all dependencies
      Pathname("#{Dir.home}/.stack/config.yaml").write <<~YAML
        ghc-options:
          "$everything": -split-sections -fPIC -fexternal-dynamic-refs
      YAML
    end

    # Let `stack` handle its own parallelization
    ENV.deparallelize { system "stack", "install", *args }
  end

  test do
    (testpath/"test.sol").write <<~SOLIDITY
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
                 shell_output("#{bin}/echidna --format text --contract True #{testpath}"))
  end
end