class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.117.tar.gz"
  sha256 "199d286c72ff4cc6557553c4c2261a4dd56a8b3cad7fa66960986e7fa870c659"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3b9a9c71a4b6cc8ef1fb51d410b39ff9ca6d5828aa8dc653b322d0bbc798c565"
    sha256 cellar: :any, arm64_tahoe:       "7049fc2cbf6f91bfd0edb32f1c0068989a881bdb182a2709a1e8c9526f9ebc6a"
    sha256 cellar: :any, arm64_sequoia:     "5a356af4f1ef1c1e7525f1d83cf7ea6463c9cc87cc8297252d7b18c8502e1d17"
    sha256 cellar: :any, arm64_linux:       "7d84791888a9f6db6733815f922162109b7c0bf4a1d018a4195e48beda729fea"
    sha256 cellar: :any, x86_64_linux:      "b17725a3d9fdc33251959322349070aaf1a716d77325bd939bbfffc31eac27b7"
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