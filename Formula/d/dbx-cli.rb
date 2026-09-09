class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.83.tar.gz"
  sha256 "4475067790d81f535092510e9c19ee1291c705815f3218ead36a2733916f0765"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7e0354574f693a4c95efc12fb3d57074dc8f4f9538c0ae95ced5208684bc1235"
    sha256 cellar: :any, arm64_sequoia: "0d1d0f52a4c45f0bdf4c73f245d0a95312d26bdf1f3a6b87e6f81d35c62559f7"
    sha256 cellar: :any, arm64_sonoma:  "a73ba51de55ffda24bfcb6773dc6c159d2117022dce7b3f206064b2a65509e83"
    sha256 cellar: :any, arm64_linux:   "5de58cd6879b5b0a62cf049cb37f2480ba7dc7adefb1895e80506580736ed4b4"
    sha256 cellar: :any, x86_64_linux:  "2e9f44bb445d8fdb228366c738f38825157fde02bf2d017d469e88a36ca328e9"
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