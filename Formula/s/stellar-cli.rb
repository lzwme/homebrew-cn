class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://ghfast.top/https://github.com/stellar/stellar-cli/archive/refs/tags/v23.0.0.tar.gz"
  sha256 "5bc73d58a9069e199caabf7a02c57301fd13d8ce71d01759c7a639d84c8b4a09"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7591b4538bac993c1b6851cbff6dea0f169ad65c0f130b208ef06ae263a98170"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16b28759a5546a30f7ff6d98cd252a66fe4ef658d8a7a6e45ff3d247617f6c61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "547070af946d47e0a4197fbe77bb9f8e7ddffa6168123cd60e1c27b7099971ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "165c6b47b367542a51ddc7f93a7c9f5eda1313d13bace24b305de42472e3a6df"
    sha256 cellar: :any_skip_relocation, ventura:       "f5a2d41fc7321a7d638966a6322a1becb1a48db861e559a7ee6d4437aa03d38d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce6b6bf8d9c5be9ff581ae6816a5211d29031b3ced9e1ca8bddee50e7d54f49f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e000e41616ffea234106c039baaaf0fdfc47a3b8ff409bfb6af2e67a072984c4"
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