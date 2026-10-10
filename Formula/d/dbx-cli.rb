class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.112.tar.gz"
  sha256 "4d81ca414a7da9d85e2c6650778ce5c9fedfa0fc519bbb0764d11578088120e2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "032c89fb8c20ab6c2726939a0ebd80e51f934e364b24a9f8df6e9c587c49041a"
    sha256 cellar: :any, arm64_tahoe:       "24ee1081e20dfa79fe2f888285ea0ad6b2fe400c78cd311cceb30d3eb2ec5ec9"
    sha256 cellar: :any, arm64_sequoia:     "c40a9bd9b0f3029e2b3f460ead0d514f79d86b319fdb6970aebd72f2285fa1ec"
    sha256 cellar: :any, arm64_linux:       "fe856e76968ecefb52967b6a998ade73d134a7cb159e84fb211f64a5037c80d9"
    sha256 cellar: :any, x86_64_linux:      "165a0c4852694f9c843a6e3f72a82f0fef20ecf4f9bd401e132f3a4795044c27"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "fontconfig"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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