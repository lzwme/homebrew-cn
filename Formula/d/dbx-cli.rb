class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.120.tar.gz"
  sha256 "5bba1c2c821205901932fcfc34da093d45b2388acf98f30bd9177816006c7dbd"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d9c89bb1b474ac49339815dd2e4adbd7ae05e4ba75e6eae5d062d2fab56428f9"
    sha256 cellar: :any, arm64_tahoe:       "629ea2b9067288f862576e4b035f3e68aa8d2685639a3c1492130ad5da302b51"
    sha256 cellar: :any, arm64_sequoia:     "d7eb7f8e6e9341a861f84145c505bf5821e81e22a5995d78fd6494a9ae744c9d"
    sha256 cellar: :any, arm64_linux:       "89372f2c0cfcb89d88509cdea75951a1851b2083b81cd8fb8294ce44a5eedd35"
    sha256 cellar: :any, x86_64_linux:      "48279cb160de8cb31b25a4198b34d8287bd0ba3988557c6f68dc46f4d30ccb92"
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