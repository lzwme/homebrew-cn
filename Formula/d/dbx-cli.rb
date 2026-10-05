class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.107.tar.gz"
  sha256 "43327b91912811a5343b446202e99d946fbf0622b7d99bd112086dde82cd3e7c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0933a73ba15d6b7b54e223eb06edb5c0c5463d8194bd510cabb8f4cda75e8b6a"
    sha256 cellar: :any, arm64_tahoe:       "78c7ebe82f4d862871f88293a88ecee739e2d8092647de310919729423f76fbc"
    sha256 cellar: :any, arm64_sequoia:     "5b08c42274639571167451d8cc02acbb9938310a08580b518f995530467cfb25"
    sha256 cellar: :any, arm64_linux:       "ca57ef3be159e37bf22e69be86c1d73301e3a7903f57c1cde4c92957ed5f7d86"
    sha256 cellar: :any, x86_64_linux:      "764cd6eba6e8e2d5ab627b8003c2429fc64c9fbcd26ad5be7e6af860e312f017"
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