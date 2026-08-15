class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.62.tar.gz"
  sha256 "1b44bd4eb61b7840fe30e8b6e817733908b5273dfe715122672f5cfb98fd2f4f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f5a8c4d4f7a134521a72aee6c03975ad124700ce314364c8bf932be1a9e1f62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41f1d313af5abe8b8d78da4e39fd7d3e10812d5b7f9c9820122e7a4b1afc2e5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "310d152359ea1c4753451fd4058b5d5071b1ca93f8e75912c92c1c34b6c74101"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c40b3d1383142fc76183bdff297bc8d17d789aaa60e0f9fdbba9ece90540087"
    sha256 cellar: :any,                 arm64_linux:   "8eaaf450261ca83196efda29389ab43cc1310d34306e3b0c3d6d9db4788120df"
    sha256 cellar: :any,                 x86_64_linux:  "9b6d2dd0a6d3dbdae552b34fd122240d29925c4042636faf06ade975962edfcf"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "fontconfig"
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