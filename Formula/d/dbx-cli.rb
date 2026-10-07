class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.108.tar.gz"
  sha256 "89a0f01131b1e83043f3c24d4b5c82e0732718e525a94d54aad778fb5d0a9c1f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9162a167a5acdcfbf02116376d2b4a5344e4340525a93379f9b550356aa7ccf9"
    sha256 cellar: :any, arm64_tahoe:       "b3243621144a533323fc8401c332b354f3f094d1041ed04d3f5943b897c38816"
    sha256 cellar: :any, arm64_sequoia:     "dec19d7a9443a4607af2323f1b6aaa5c83373b8b6c880a76a94875bfa8a4343c"
    sha256 cellar: :any, arm64_linux:       "d1c3de7bf2d1da665531e74b95e0b4b77cac0f4a449a457c0047905698da27b3"
    sha256 cellar: :any, x86_64_linux:      "548f9fc52ecc19ca7fc0a34663935d91e9210be608ccfd3d0769499452c48b3f"
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