class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.103.tar.gz"
  sha256 "7f391da7654046a98f613fe27d0bafe04d2359e67e80a3e9f62df926f9914c97"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0d0c3699b8fd2676c1debcd27ca377cc11de932ae5cb027b6963c73d73364a17"
    sha256 cellar: :any, arm64_tahoe:       "e2c02d24ea9199470f4f1ef0a9d1346aa941777e999da1275564f5343074dc52"
    sha256 cellar: :any, arm64_sequoia:     "86af6cbf41d1948e9535cb175f4b5a82662d65b74bc9eb8ef4d335dc4e08a2de"
    sha256 cellar: :any, arm64_linux:       "523e740fbda1edf96ed277d0639f78c9fe2e052bd1a3607c586c677a676ce7d2"
    sha256 cellar: :any, x86_64_linux:      "de539fcf7ae592d089f4e75196bb5cf8c3c5aa8634d6acb6d70278126cf260e2"
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