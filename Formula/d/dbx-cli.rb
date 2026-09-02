class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.77.tar.gz"
  sha256 "009a0a9d3805f18fd255a50f1bd00b843c5ed856c465ade65bf1dbafec880715"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4f955d33f116c00aba0fadb6a9690a1cfe09ff0655fd0b7487afe849f2bef006"
    sha256 cellar: :any, arm64_sequoia: "02239c758930f4e464deb60e098836436c372a57fa311bd8c480ff64e4308b41"
    sha256 cellar: :any, arm64_sonoma:  "208b332d3a6f844ebe5d24974ba7056c65fb71a05a4bc8b706b721757fbfab81"
    sha256 cellar: :any, arm64_linux:   "72841aeaae9e05e6e43586e37508206ab602f0c098d0793cdf25e83d49a604b4"
    sha256 cellar: :any, x86_64_linux:  "d467172deda0d4df6bca7f756f678ee9dae81179fb2cec1f9075cc0ae314f80a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

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