class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://ghfast.top/https://github.com/stellar/stellar-cli/archive/refs/tags/v23.2.0.tar.gz"
  sha256 "8966f9f48b12d253f4f2f7da4390c225b39e1f26f0b4b0344551caef5fd1b528"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c40903e4896ded3ad56c93a1c0fc15c8372ffe3f7e6e6853d4890805ecaf9626"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9908d565df1e198cef5ea75ffa03c245e27ff5d78415df8d603507cb4f31b90e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4f48cca02914380b79f3c5c4a879e0c56c64c982b5b2618a6dfe906833359f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b5219a5d4f06c1d6c9ddeee1d48c81a408226b9a02925a5cbf1982032f0af3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3aa820114f76f8edd5253b067fbbda7bee73eade17ea5826cf5ef8539469c484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1132f6e59c583ce60c7f622b38501c29298d034f37e58a1742449c5e33498d1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "dbus"
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", "--bin=stellar", *std_cargo_args(path: "cmd/stellar-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stellar version")
    assert_match "TransactionEnvelope", shell_output("#{bin}/stellar xdr types list")
  end
end