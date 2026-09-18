class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.90.tar.gz"
  sha256 "cba7e4247b48331e8b5407ac683a1953312330c6190ca6cd826ee9afa0648823"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fb5e899910521eed240bee50927289dc7857822c843f70bf60d6892d2ca90e52"
    sha256 cellar: :any, arm64_tahoe:       "2dcdfdd64d2e1e2abb554ed4ccc884dd437c4b0c9d32e7f02cc084b7b8d532a1"
    sha256 cellar: :any, arm64_sequoia:     "fb36709bacf9ab834ddd566832ae79a845f3bf5247a0985a6f6c483f180ad8e1"
    sha256 cellar: :any, arm64_linux:       "e69e69243ec9d4f255149a35036b4f0c0e86b1b53cf1c8548aa6f0c335df3357"
    sha256 cellar: :any, x86_64_linux:      "7273db164c3120e5d981d063d5dab90d3e1ad5bf4932ee5564acae00f3471e37"
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