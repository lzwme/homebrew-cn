class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.131.tar.gz"
  sha256 "80da2862ef07b462d39fdfd4c4b410828180293b2ae84520ba4dc3cd35e2b177"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3abeff49c3c13c03b199c2da9ed8df3b6a8bb531dafd4936ca2e1169e4ddd8b5"
    sha256 cellar: :any, arm64_tahoe:       "70eccda823ad05f6eb7c9b6f3422830545cd7d297abfb52faec70be1491ed2b3"
    sha256 cellar: :any, arm64_sequoia:     "6e86e1079da0affbf4f12f217fc559e9e8cd2dba954829d68ce7d6c344ec6792"
    sha256 cellar: :any, arm64_linux:       "72ae56cf9b226072f255b8850ad621cf09663d77c88509ec34dc7adc7948c307"
    sha256 cellar: :any, x86_64_linux:      "5561b5cad339f910bf550e677de7394cbe558d75cbadcbde723ac354c2fe26da"
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