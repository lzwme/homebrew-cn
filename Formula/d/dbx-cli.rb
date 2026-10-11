class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.114.tar.gz"
  sha256 "fcf16dccda53b93ed2760cd188164d5d85fbf2de058f6d20c710f51e575444fd"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6f0aa5dcdf6a1f2c91cb7f30b71a9ec45cfe56c8a119338ab0ce05dee8e264cf"
    sha256 cellar: :any, arm64_tahoe:       "454ecdf0336b570612dec6cdce67d3de1a22c6221bf7cb326cc2a8b15dde99c9"
    sha256 cellar: :any, arm64_sequoia:     "0b1b5301c85d6eba83f88019237878e278d09160c97e849d9b6728f76ca7f742"
    sha256 cellar: :any, arm64_linux:       "b9c6ea8ec155c95f24509dca3c8ed8029d874d4a47f7c3ef6110ed8462b41379"
    sha256 cellar: :any, x86_64_linux:      "6a0218143027702e13c91f43f5ca205adb83ad8ec53c90528c7f54954e9f0ecb"
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