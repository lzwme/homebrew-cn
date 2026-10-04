class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.105.tar.gz"
  sha256 "108be9b0c53c014375873c9b173b93f7a13f09b21236026fedf3eeb9c77cfd7e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4f6c30926202607d5de43a3f49041769094a932de1cdcabbce3914cdf73198ea"
    sha256 cellar: :any, arm64_tahoe:       "37f6cdacf04a96caa1562a717aa91c6dabbffb6310d6edb3bbeb3f05d3035c82"
    sha256 cellar: :any, arm64_sequoia:     "94f19beb37c5365bea02f34845102f59f04f2cba7421365394aa8c0a68ae3151"
    sha256 cellar: :any, arm64_linux:       "10d73213f33ca6d3f9584f42343f52291f0b32ce68af13a28f92b4b14eeb571a"
    sha256 cellar: :any, x86_64_linux:      "fd840d1dcfedc60353e334ca0f88feb9d8a7ec5f64e95af347c1854d7aac0225"
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