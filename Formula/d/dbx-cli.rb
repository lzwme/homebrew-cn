class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.91.tar.gz"
  sha256 "64d795697def7ec02917e27be53fb83b7a3b018ec20602bab58a4ee052e95d52"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bd1fcda4c5e66a017c9c8541bdbcd202afc2f1064a1196a630d5968fef58dcee"
    sha256 cellar: :any, arm64_tahoe:       "2ada9488fa8ece9987a04eee7fa17ebbdff164c1d23bf5d7cdb9f7d6455ef7bf"
    sha256 cellar: :any, arm64_sequoia:     "1eb1a5507ee8b6fd3cadb0ffa990ed45f9e0d65327eeba2f9ab66f2677f56bf6"
    sha256 cellar: :any, arm64_linux:       "18042f79886a2f66bbec12ec4742a2140b055edfbd3b314fd54e0f0088519e0a"
    sha256 cellar: :any, x86_64_linux:      "68c3de066fac8289b893421274e52e8e646cda6358d68aaf0b4f7a73a077d84a"
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