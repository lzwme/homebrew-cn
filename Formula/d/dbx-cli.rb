class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.130.tar.gz"
  sha256 "9d491cd5a934d4175016ce03666697ee38684a133697c598254ec50bb623a4a3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "26eacdf86bbbcc13ae0060ecc5d8c215a8d224ff42b0c52b396376fabb1291a5"
    sha256 cellar: :any, arm64_tahoe:       "f537fdd8e1eb1faa2991fe07e8810a73ec1a78b3cbcff62edc5e8fecc65cf255"
    sha256 cellar: :any, arm64_sequoia:     "09cbc1d0155998387f87f847088fd37714c0029a6352085e56a7c717a0d9ea57"
    sha256 cellar: :any, arm64_linux:       "e7449e605c4dbac74910e5304499147e04e67a2d37ea64cc8a0857e065f56e60"
    sha256 cellar: :any, x86_64_linux:      "444e41adb9ec2807070b96788a712166d7b192ae07aa69bb1706dbbf27b31b97"
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