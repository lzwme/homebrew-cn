class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://secure-contracts.com/program-analysis/echidna/index.html"
  url "https://ghfast.top/https://github.com/crytic/echidna/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "fab7817640a613856365766031518a8bde5471a9fb14618dfb0b77e3820a7cba"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0841be5b437982ee4fd47035bfc50943e1f666dd9e0d799d91ef0983c03adbf5"
    sha256 cellar: :any, arm64_sequoia: "b13d342c4a8da088b965e49ff883e9cd1b031da78ff33e3d2ecfeb477cf4927d"
    sha256 cellar: :any, arm64_sonoma:  "ff6e92e25818029501df92c3dac81dd997a804edae3986fa1e1dbdf69273c7fc"
    sha256 cellar: :any, sonoma:        "559cc5820d60a42a081997c59e80432dc084a94b3e43200ffef46b35c1886400"
    sha256 cellar: :any, arm64_linux:   "81a8f95b38b0beb4c70d2b25cfeb8d7af3996be71c7b31b5c89d43b1e6e03294"
    sha256 cellar: :any, x86_64_linux:  "dd2432167909da5b642b29db01710396fcbd250befe602375342aa2ed20cf233"
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

    # Old version doesn't support base >=4.20 which comes with GHC 9.10+
    inreplace "stack.yaml", "allow-newer-deps:", "allow-newer-deps:\n- aeson-optics"

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