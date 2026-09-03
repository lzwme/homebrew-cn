class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.78.tar.gz"
  sha256 "046c8faacd3e3aa272dde7c8d40023e7943703264dfc07ebad52362058ad0f22"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b8b5aa32066da33745403e253d30c31c19e7c8c055f0282e0c3ddfce12654ce0"
    sha256 cellar: :any, arm64_sequoia: "074486720c2af8fa28349ed2e3811c96ddbae2e0e0fccd23c53bd94cfb87f765"
    sha256 cellar: :any, arm64_sonoma:  "9a9f3a34be4bbc3bc4ad39bc74b3ade24fb23d71c3c14c953e9787528e7264e9"
    sha256 cellar: :any, arm64_linux:   "b0404657ed6b27ce2c7bbe9916352ee4e43217747ba5b4fc90c1bfa964a5a66b"
    sha256 cellar: :any, x86_64_linux:  "7c98e3952fda0ed383a25f485616a5c66b389ff46d4a870be8dcc9aaf1804b37"
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