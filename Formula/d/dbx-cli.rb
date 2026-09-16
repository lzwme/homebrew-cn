class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.88.tar.gz"
  sha256 "291ab055afa9feddf095c32fc9414bbfe6f5385eca8e48892a0218885b799251"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1c6b61676a2f7bec75647d2c8ce3b9aa6d78296875d1a1780c090a08dc6dd868"
    sha256 cellar: :any, arm64_tahoe:       "c83d3c5013e8af23b8a1cf2c225567e4bd61b3daf08a709df592772e94d6bb76"
    sha256 cellar: :any, arm64_sequoia:     "63dd53eabc2072457a6983e11e8938f557ad7f070cc9ee4201ac63ecb2cf4ef4"
    sha256 cellar: :any, arm64_linux:       "9318d34a27ffc5273e5884314fd208bbe2e9982e3ccc505f0b03f82c58e5db9f"
    sha256 cellar: :any, x86_64_linux:      "df413fa8bfb1188b65eb0f268a35b1e801904922e056e7f72aefbc36ce48c827"
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