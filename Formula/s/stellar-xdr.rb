class StellarXdr < Formula
  desc "Stellar command-line tool for encoding/decoding XDR for the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://static.crates.io/crates/stellar-xdr/stellar-xdr-28.0.1.crate"
  sha256 "52599dcc4daa661c19d912f5ad55322772515a198c0da3c985ef3922f7f40b77"
  license "Apache-2.0"
  head "https://github.com/stellar/rs-stellar-xdr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6b4928eb43c7c0c42fe95eacb83a28564d964b4966b51bf71c98d93cb9fa4539"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "290f0245109e45c46c480b0e2e4f4e848d4aa28a5320ec32b05b40e38f1a5232"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "38a267112368edebc99bca85a97fcb9d98e7f9db8becabb1abe8b638510ec348"
    sha256 cellar: :any,                 arm64_linux:       "305cea2e349936dff07f59eaa5b97c0edff9613e80d6555cf5e290196d960832"
    sha256 cellar: :any,                 x86_64_linux:      "a21898a612d01248fb88a24a4f83c329561397eb65247b514d1e7ee73731289c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stellar-xdr version")
    input = "AAAAAAADJH/////9AAAAAA=="
    expected = '{"fee_charged":"205951","result":"tx_too_late","ext":"v0"}'
    assert_match expected, pipe_output("#{bin}/stellar-xdr decode --type TransactionResult", input, 0)
  end
end