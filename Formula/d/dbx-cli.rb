class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.118.tar.gz"
  sha256 "ec5fa2adb80eea6b4071d929205bd80b091d68968e27a721eedcf0bec1118b7f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d3e6fedee53a8adc1277a94b133e5fd9182b9bf7198d7f462a2d862da9fed259"
    sha256 cellar: :any, arm64_tahoe:       "58a06fb6ad3d30023e811fbb2cd0eed14e42e17802abb39bd7f1aa1699ac972d"
    sha256 cellar: :any, arm64_sequoia:     "7fba1f9f0c5491a8c7aa05800a3d12f3ba79aa1a298a52b6c82e9a989b83843b"
    sha256 cellar: :any, arm64_linux:       "17e9cb656ce7ab785360c49bcfa9c80ece082d90fb7150f8446e5902cd534ca4"
    sha256 cellar: :any, x86_64_linux:      "0a077bba35d19a30f30bac91e3429763d7be28e51e5fec5b8a53c6d6afe13e57"
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