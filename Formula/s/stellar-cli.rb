class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://ghfast.top/https://github.com/stellar/stellar-cli/archive/refs/tags/v23.1.2.tar.gz"
  sha256 "d09b2c58e7e72b0a0bfae11f24aac5c5d817ff8d670c06e50520170189bdf8a3"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0009202235f9b190f6cffb78792b3605dff2252a5ddae168e18003091bb577d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ccfee8584abb720344dde7dd9101086a207a85ae3d89b2bbdb7c61f5a584443"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c68bf4ea5e012517db79f5ea152593829307d96077c4bfe4a9ac22e862c8c76d"
    sha256 cellar: :any_skip_relocation, sonoma:        "af86b81cb8d9ff0af2042b52e28bdc8770ff276a187187cd1774d13b32a25825"
    sha256 cellar: :any_skip_relocation, ventura:       "e104b74ba1c53da259dd49648b08305fee89ab920ffc7252b453182e6ea11b07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cf1322103de443f29e64c7a37f0ea1140dd30b47d676cfbb910a1e58f0d1665"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7491f7961a2c508efc4396e8df102c693c9a1095d7b60051b3a2dd27538b4f9"
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