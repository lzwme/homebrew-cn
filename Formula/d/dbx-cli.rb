class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.135.tar.gz"
  sha256 "281adab7405eb0e195607fc850179f3a5ed9f031c6e686d6b51eab864e799e11"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7b0cd7ee5775e089ad1a9d21782885796654fd4db7323fb6be3eea930ce03340"
    sha256 cellar: :any, arm64_tahoe:       "35bfc2d5574181f60d94ccf7224e36774895c6db53dbdbf63d3dc2b14fa51019"
    sha256 cellar: :any, arm64_sequoia:     "dd90d64776569dda5412514566c63fffd18d561071d3e15bb4a5c448ae994e41"
    sha256 cellar: :any, arm64_linux:       "aea74fd38b93f95dadbba43db7f8fc375528355278b563c6aeeed6ee7fa941e7"
    sha256 cellar: :any, x86_64_linux:      "9783758ae5b6f52fcb4cf18a47ccdacfa665f2043e2cdce08f3f38ecc8fa608d"
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