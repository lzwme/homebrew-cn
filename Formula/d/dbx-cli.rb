class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.56.tar.gz"
  sha256 "b5bb2af92471d034e428c1c8095edb9c256b52fdbca9e85ed955775f377f4f9f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3fec890f4bfac2afd604ec05197809e89324de777cad0b9db6d3fc4763812eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1dec3bbbf4ba54e72f827bb2589445f0650012852d6f1a888455f96011f5bce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74861987a0aa8854446d3ab71518796cbe146137dd212642fac13307e619da2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fb71e9de5a2077af037e5e0dc463708b66cf42a58b91cc6fa9fc2ea4329a5c9"
    sha256 cellar: :any,                 arm64_linux:   "b86a2a3eb970d0f39835116249265eba5eef105bcfed3f242c3f4d42e3b40e73"
    sha256 cellar: :any,                 x86_64_linux:  "16d66712e7c65075afc2312324740c4baae428abaffde7729689bb735198e7aa"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

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