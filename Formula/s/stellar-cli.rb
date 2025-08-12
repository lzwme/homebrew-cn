class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://ghfast.top/https://github.com/stellar/stellar-cli/archive/refs/tags/v23.0.1.tar.gz"
  sha256 "1ea322bd7ae7fa69140c2c80d40f8d7fcf86655878f80f3396d9e45cac1d8fa1"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bcdd9fba100fbe55629ea2669a680a8dab89dfdabf9357276b884dedc9daa67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78d5c91ed8aa4d66767bb340cd31ddf4eccb07a6fdbc3c1523d13270608ea734"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c7aed54d9c8b9d8c6704e7e4154c84e1fb89c2c271cb048ffee645b77da2434"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ff399676b97a7aa2c4cb44d61548ba2eda350c1947d6767cbba8b8af01d720d"
    sha256 cellar: :any_skip_relocation, ventura:       "5ff957fe189aebcaa3f9fc648ae22b5e2a842d4fff59b6e335fd519154a5181c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d0ecd57c6799720fa9e8931d980a62d1624c2668b8ebffcd7bf7d816cd361c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dc23093c2f2717da275a19f751812ae49a334ad9a980eef89f74f10fc158648"
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