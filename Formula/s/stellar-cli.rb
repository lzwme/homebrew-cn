class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://ghfast.top/https://github.com/stellar/stellar-cli/archive/refs/tags/v23.3.0.tar.gz"
  sha256 "52dec385891110256241e2c2d01c280ebd5a7a8ae04b86a90c5a2d6b84d4f825"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89e00435b3157fc17d91dd1d3d7ea2b9027cb362a36e1a84e883d877c33d88bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32d547bfebc513048bac490e50de679c8b51f4260b6d131735efc9d6b3ce71ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3da8b543c28b002bce5a15dd818e20c10a8daa6185e110721017bc09b90fa9fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "4633421dc09dc6c8e386f8824e88aa1bcb61038789e146f98b746fd58eb09c16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c85ce13e5af8481a2c288d7087640a376a161d4489d722b5ed2d35684e77bef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bc0e1944e4c02e218dbfcebcf99777ecb34690bddab122b5ee07e9d9c6a534d"
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