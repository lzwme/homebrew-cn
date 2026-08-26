class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.73.tar.gz"
  sha256 "deb3635d29a5b5dbb5571d9e5767ef803458d55263d70818008a2109b9b63e1f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "82454f932193ef8603bc61c7a2c53a54c14f9cea0aefb553cff921813da189d1"
    sha256 cellar: :any, arm64_sequoia: "cd7676826a6780e02fd8914356281de0e3ce939dd25569115f86edd32d83b9f9"
    sha256 cellar: :any, arm64_sonoma:  "2dbc2b7a32f56d6d49c6525260eec69ee61871577825caa3015f53f5238ba456"
    sha256 cellar: :any, sonoma:        "7b9a0e963ad511e2998a677cfde60e4a37453fa15221cbc064d69f858e2b3429"
    sha256 cellar: :any, arm64_linux:   "b6ee7b7612c2095e61ec9e42f6f809ef8f4369bd196596e7a657a9ad8a390e9d"
    sha256 cellar: :any, x86_64_linux:  "7be5b883a8f81230d6c71456ca3e1114311d0ad53d65e37c088570a9d3257361"
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