class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.93.tar.gz"
  sha256 "bae57c36c0fda8dab7109b924752cbefbef75e064c87867c84583dbca61a7b35"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "61f6ba9bded83829beac8aadaceef40758696606ab97cc302a609b08e89c845a"
    sha256 cellar: :any, arm64_tahoe:       "6b20c63b32cad163c6f9c8fb133baa058ab2987b681fd027cf5b2cfcd92f62f5"
    sha256 cellar: :any, arm64_sequoia:     "df62c5b4ec01cc28b602c7ca90309910c9bf91eb00dab3c08761f7108a504557"
    sha256 cellar: :any, arm64_linux:       "a7485b19994efff3cfa3a98a8417c5011056e0aff414921f14e5012560bb8601"
    sha256 cellar: :any, x86_64_linux:      "0f6ee100eaec7fe7220b842e9be47d9c6be1510df473383c4b3fb3133b68432d"
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