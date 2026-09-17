class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.89.tar.gz"
  sha256 "af5b14491d0b1755cb388d9bcb7f4e6b319dce0be18d7394c00b8138892727a1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "371376e63dc89711f11d47f8db612800bd48067683aa43b0ce1bae4ea23a6a06"
    sha256 cellar: :any, arm64_tahoe:       "c130230f3bcd7c0455b58936845b3c6735c630886305fd9f4210b4f47c978c3f"
    sha256 cellar: :any, arm64_sequoia:     "aa3071ee594b8d4a96d3e39d1205aa11a28a02657145c9d2aa760f43144d3675"
    sha256 cellar: :any, arm64_linux:       "e50fbbc682b42a56ce5897b425c41909f3717502ee24380965f9901b285a6814"
    sha256 cellar: :any, x86_64_linux:      "d0360a537ac18a9b9302bcc2d8736aaa7577de78ebc47dc7c113567b3d6b20b2"
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