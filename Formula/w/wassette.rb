class Wassette < Formula
  desc "Security-oriented runtime that runs WebAssembly Components via MCP"
  homepage "https://microsoft.github.io/wassette/"
  url "https://ghfast.top/https://github.com/microsoft/wassette/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "ed6ae36056fed2dc11f734623ca97f74159f648367b12c2d49c559b126f27ac0"
  license "MIT"
  head "https://github.com/microsoft/wassette.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0639940e35827cef3ba3e613c3560967feaba99515667d7e5b7c5c0e16a7d76c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ffd6ea5278efef2b205993848c9c535261c5baf5e001f974e0c5e1b76ca1d66f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ccc255e072c78068b7120477420775932711c36959952e1082280527fd651721"
    sha256 cellar: :any,                 arm64_linux:       "10b3a5e73c5dea1e040849cf45c308ef027dcb39fc3ae2b3d7905cfb4b0158eb"
    sha256 cellar: :any,                 x86_64_linux:      "32055048cdfadfb84e989245172572111544190934096e729c2a5e7fb2b6ba29"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def crate_path = "crates/wassette-mcp-server"

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "#{crate_path}/Cargo.toml"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: crate_path)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wassette --version")

    output = shell_output("#{bin}/wassette component list")
    assert_equal "0", JSON.parse(output)["total"].to_s
  end
end