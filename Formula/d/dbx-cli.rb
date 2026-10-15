class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.119.tar.gz"
  sha256 "891fd0bb87e322d663e1b148ddf5b9357f728c1fc244de355bbcd4298cb6229f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b2b8daf32342384f248d85abd5f22d91e123ffd27744da1fecf73e2cf793d4bc"
    sha256 cellar: :any, arm64_tahoe:       "b3b81dfda04a6b8cb74f4ef017f81b0fdf2b17136fc06dce09bf10aabee20e4d"
    sha256 cellar: :any, arm64_sequoia:     "d15df9632392765754e20032ddb8498bb78bb5ea290d231c088930bf9118c056"
    sha256 cellar: :any, arm64_linux:       "96124c1983a022a371bb9b2c9c642b7f77329ab0029bd6c96f3423befce718bb"
    sha256 cellar: :any, x86_64_linux:      "21ccdd0b2bdfd517db8c6c1a1b7d346296496f642f04170d478aa5f4621e78fd"
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