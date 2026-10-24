class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.128.tar.gz"
  sha256 "5e8332698f09f49c82eb58428ec9737c8e1d4931a6ea7949cfe5eb765a5b2823"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ac87f6f2854eae42df3b18b43bd359570a8fd8c6c7d3e905e151da4f321a36af"
    sha256 cellar: :any, arm64_tahoe:       "e81322a85e866125a34fc83239de033d165318faf757da5dffb31d3c937f5017"
    sha256 cellar: :any, arm64_sequoia:     "82def3b605afc39eef58ebd9ab65ec5b948cc85da0663e7bdb17acd0c79fb6ad"
    sha256 cellar: :any, arm64_linux:       "a4cf072d53c964e0a00bb8d9e244cff9c2d2e049ec7e77ab54fd9e96454f7a5e"
    sha256 cellar: :any, x86_64_linux:      "ed50b148bd3693aa0c279accb85b1d7b2d4a067850dd1061172dc4e7c261a428"
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