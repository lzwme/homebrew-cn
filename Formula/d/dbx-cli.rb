class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.94.tar.gz"
  sha256 "a833a0452ffa1edf4a51188b645ca475d58d82e27893523a149754215ac3fb1a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ce622ad6b98d1d86892d0434ccf273982b89c3d3c91c174a9a1dd1a8c9eb3e48"
    sha256 cellar: :any, arm64_tahoe:       "6f6f460fa897246101de1d21b7d5ae2bdd406e7f26999aab11f6cb0c63339ebc"
    sha256 cellar: :any, arm64_sequoia:     "cc769415341fea619aecce385e18960a260a9e64f40dc26ecb24a77b7c173993"
    sha256 cellar: :any, arm64_linux:       "e1965ede4119850a00f9432392f98b9860acb73e0345928f9f02b28177a9cec7"
    sha256 cellar: :any, x86_64_linux:      "2ef1c3898031793c20413bc5892e34d4bda963107ac0f42e60803a1d2402a945"
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