class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.127.tar.gz"
  sha256 "08fb252c9bdd5de5ca45147064e341d6ffeac8c6c9324f72ab22722ba5d0dee6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3ec81ed29f33b047dd2aaa0c96bf9c086d2074769cdea705a938cdf5a477cef2"
    sha256 cellar: :any, arm64_tahoe:       "1e93c7c8619eb91b4b53970d49fe85c24d8130da5d890fe38af4e7cca7a01ad9"
    sha256 cellar: :any, arm64_sequoia:     "ae1afb7a7cc7876f06fd6d325cb30b0bdd95d35f405cdb7b778fbac4b658c911"
    sha256 cellar: :any, arm64_linux:       "d53fd0c78643b85d151cec7ceae78bc003307c56b3ab0cae17a949a83c52d2aa"
    sha256 cellar: :any, x86_64_linux:      "86e2545b3da6b520c40c8bcfa237a65555c9f876d64426338c7ba4630b1e1b9a"
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