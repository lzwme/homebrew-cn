class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.86.tar.gz"
  sha256 "abe776327039d1122fd1a4d6660fc2f7f9d76e8cfed0831eb990d2ad83608d35"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7fa3e2667b12259deb00b3b79cfd582d7bc4ca659c1108048a72c98f9004b9f9"
    sha256 cellar: :any, arm64_tahoe:       "72950001f5826d9c71fe3935463da63b64e8f84b0dfce8ae740cc5a08a492722"
    sha256 cellar: :any, arm64_sequoia:     "a724a2c170c6cafdc0f5fb9d8125910e9ea4f22b08651f89ebe7e81a63069b90"
    sha256 cellar: :any, arm64_linux:       "d2e2709979259493d9f3f904029ceb39d357233cce2fd8b63b80df872f5ff1dd"
    sha256 cellar: :any, x86_64_linux:      "5dcfbfe5b122f91057215ab0f24c0b824e0285127c85ef51202d54b6756e5855"
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