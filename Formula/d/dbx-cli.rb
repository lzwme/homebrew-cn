class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.132.tar.gz"
  sha256 "5b1139dfa2158df1cbe240d5b4b5718bebfa10ae19859b2c6012584abcd438fa"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4befdc2271464f305be140871bd5f329f7c03ea50da658c8801634ca2167d3ba"
    sha256 cellar: :any, arm64_tahoe:       "333aaff761ac7d4994b64ec1b8a718edec4a88ea0073fe1ae2c8f367b8c38588"
    sha256 cellar: :any, arm64_sequoia:     "62ecedfe4df7f1b8a31fc1583d77c7f288f0bb6ca6ba56fecb93b491e28f8f91"
    sha256 cellar: :any, arm64_linux:       "800aff442d6027ccc8cdea16f13e6023b709dc27123850c1d59805b8db1cdbab"
    sha256 cellar: :any, x86_64_linux:      "806e61a79d20e38a432aaa147b1b9fbf555c2c8e11fe4184debb16ebc42c1460"
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