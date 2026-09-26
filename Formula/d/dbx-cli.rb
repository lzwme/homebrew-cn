class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.98.tar.gz"
  sha256 "10ff110588ecbfba5891548bc373997c1b7a7c610a80759005e671a5506802b3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bc6482a4b9859ef36a993e33487b1bfd0ee4c9e7d12bda45bf549777293edef1"
    sha256 cellar: :any, arm64_tahoe:       "33265a57cdc07b67c78a8c865c61b29db0c82ebab99ea7133c1aba54a3c99d78"
    sha256 cellar: :any, arm64_sequoia:     "8e192ff5636f0ab035e455af9c5b250c2f88b5974d3b8daadb5c416c1d655613"
    sha256 cellar: :any, arm64_linux:       "a5d1dc48a564ce837f470ce9a8551a0e6688c5ee849702d85d5fab03b67d320b"
    sha256 cellar: :any, x86_64_linux:      "a64a2b4749fce3c346af0dbb90599c7f3d6fb762a9cffcd426eab156f47e3be1"
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