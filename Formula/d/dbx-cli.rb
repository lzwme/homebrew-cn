class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.123.tar.gz"
  sha256 "9a83378bb9a62d0ca88a43857c9ed13035cb90285a8e5f68edfe31705ec34175"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7c139f705d3b074900cca7acf6a30f9b0454423dc0e42bb608391617e9199e91"
    sha256 cellar: :any, arm64_tahoe:       "83c56f4d84cdc5700d49e0ae563f7afa6ec6f59ad29301f6b780257b3bd3c35a"
    sha256 cellar: :any, arm64_sequoia:     "3f70b1bdbe4b616f3e175d61a11bb2c71013736a6540fcdbfba36d16991fa8ed"
    sha256 cellar: :any, arm64_linux:       "3010916d7f77a8bf3a68e9e7fb4c38c726231f2af764c0b3c77aebce93d28b04"
    sha256 cellar: :any, x86_64_linux:      "2d632ea2703132549d833e888f6a435b3256d10ff00e8554d9e54fe711ccf4eb"
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