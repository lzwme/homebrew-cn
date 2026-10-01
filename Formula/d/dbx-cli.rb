class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.101.tar.gz"
  sha256 "5cbab4441857276fea52ebabf1f0c092284da2b8657c5b36088af1f02c02d0b6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0d3575377b222454e80fd63b485335126ec91769cd3891382fae9e5c79c622e8"
    sha256 cellar: :any, arm64_tahoe:       "13a5e0e3bd6afa7cf0c54a144f164a6411d28ad2811fca7debb34c717d3ad611"
    sha256 cellar: :any, arm64_sequoia:     "496f7fdedaf09d1c670cfd0b1db3f7fbbbb6ecba0c0976efb88ae4a35b4a5dbf"
    sha256 cellar: :any, arm64_linux:       "fd324d4fb74ad601c188aa46c87006857adc5601967794e0ef6ae809c72cab41"
    sha256 cellar: :any, x86_64_linux:      "a7bbe6d5bc1a4583071d36baa9243064a8d8faad939c67c2e8d829b74b6241fc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "fontconfig"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dbx-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbx --version")

    output = shell_output("#{bin}/dbx capabilities --json")
    capabilities = JSON.parse(output)
    assert capabilities.key?("directQueryTypes"), "Missing directQueryTypes"
    assert capabilities.key?("bridgeRequiredTypes"), "Missing bridgeRequiredTypes"
    assert capabilities["directQueryTypes"].is_a?(Array), "directQueryTypes should be an array"
  end
end