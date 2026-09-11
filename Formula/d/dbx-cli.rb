class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.85.tar.gz"
  sha256 "4dd1dfd5488335c41c3b127b47280bb427c46f7bab3174a686979022b669edd8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "50fe4a92b0730073af4d5af785005767f8d7257957571859198b98078ee00fe3"
    sha256 cellar: :any, arm64_sequoia: "9501e232ed75de47f6ac5abb2cc49df2a62a9f74553b65788b56e718d8e67f5b"
    sha256 cellar: :any, arm64_sonoma:  "3c49e85915d4bd99636026d442dd4dae843ab976e5792072eb6aa7e478bdbd34"
    sha256 cellar: :any, arm64_linux:   "c81c907e6fb37f8d101e12d71d64ea13704c486d55517364d3ad1ecfc9fe6854"
    sha256 cellar: :any, x86_64_linux:  "772983da137cc4a63d1ccfaf4d3755437dc263d9767a4d6a8d9bcc4d8d576611"
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