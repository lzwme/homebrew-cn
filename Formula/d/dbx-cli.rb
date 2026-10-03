class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.104.tar.gz"
  sha256 "3b530c7855a19e20f4744a7d863c8935b40719af2fade559e4357d02af9b2106"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0a3c8d465914078b46b0b22d04cca47b4bf27042e1820bd7e0d1128b44e413d2"
    sha256 cellar: :any, arm64_tahoe:       "e3ceb3a6fb59bcb35690cfa2d8dbb496199acd26a55e53056d9f8b3e7fbd4ff6"
    sha256 cellar: :any, arm64_sequoia:     "40a01c7378298a0787c28a46e8975ae775ec68d01d8ad04c188fbfa579e7bf97"
    sha256 cellar: :any, arm64_linux:       "17a7dc30e1e287885151068f44e789c5a72dd982fb6e11ed1ddba6e2e0b87eb7"
    sha256 cellar: :any, x86_64_linux:      "51922ecd2e8897d335799a9424683bba0d8e83634322a94a6af4a1675453b11e"
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