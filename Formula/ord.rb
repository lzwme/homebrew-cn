class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://ghproxy.com/https://github.com/ordinals/ord/archive/refs/tags/0.6.2.tar.gz"
  sha256 "79bcac2082d9cef4655e85048c3dba28f23a868556416352169b0541d60a20f7"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cc9785ffbb9e448f427285b80b585eb2bca0f150440fca203c69842d74693f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02cc79ee88d09cb03bc42798d9de029849541d0d8f2b8d8c646d1efa69b0cfc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a78150fc256a0f34072d1f02026ff97f203663cd425e796704592a9d24a5434"
    sha256 cellar: :any_skip_relocation, ventura:        "b278f6c8e7e1432db782ffb55506921c66f6baf5a434d234dabcdadf35e77b21"
    sha256 cellar: :any_skip_relocation, monterey:       "3caf8f25dc0d1d77292103e67c1e55e253c55260c568e80346deb5b2da43fe35"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7f39b2cdc18dfe45d770bed7a5cc3df988a52ea91aa0f7ee56a83091dee83ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61e22f83f20d2dd3951d1fec8b433a3fd7ea11b52c8701bfcc61ed42fd19b9cd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = "error: failed to connect to Bitcoin Core RPC at 127.0.0.1:8332/wallet/ord"
    assert_match expected, shell_output("#{bin}/ord info 2>&1", 1)

    expected = "error: failed to spawn `bitcoind`"
    assert_match expected, shell_output("#{bin}/ord preview 2>&1", 1)

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end