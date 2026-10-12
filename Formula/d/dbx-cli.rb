class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.116.tar.gz"
  sha256 "d136b0745e8c534e0cd677bd59974cf8c9547fca12f2894042ae4048143120f8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8228ce3c0d01938502f66af817a6e63ed4d4a849baba66b1d201b50f9dde6026"
    sha256 cellar: :any, arm64_tahoe:       "6daa6d8ffdfc2f60d4ebae598ab15de917e6506a1a88eb2d7d9a5ec85529a7d0"
    sha256 cellar: :any, arm64_sequoia:     "d926445f5b5a70c58f2622a18d7d37d3cba79b630eb217062135f74583f7849f"
    sha256 cellar: :any, arm64_linux:       "09211546254508e6895a90e7c7e5b5629a888f68ba6d308a9e1e53d6e16bc03e"
    sha256 cellar: :any, x86_64_linux:      "2aa06c6c0ca5ac2b536ad9109d86dcd1913d2a1e689b5ceb6b9f9c8a00def951"
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