class Wassette < Formula
  desc "Security-oriented runtime that runs WebAssembly Components via MCP"
  homepage "https://microsoft.github.io/wassette/"
  url "https://ghfast.top/https://github.com/microsoft/wassette/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "2b806f53a251bf038bc768f22af20a50e5c92d630c3b4c4d115c13f2cc381266"
  license "MIT"
  head "https://github.com/microsoft/wassette.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "874e1e02934b06938d5a58d63111fb3bffd3ddbf3c3227211deb92ef9a75ac22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7321b646c81597bac0b728cf6191a86030217a171f9480fa8c0c3b944a86412e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c26f159a91cc7ada77122b6d9136be782da2be3f86e877d0ca56c48752ceda5f"
    sha256 cellar: :any,                 arm64_linux:   "b96a77ad983a2f1c19c6112b8b18298efc8071b8fa9f43913e49daf1a8f795dc"
    sha256 cellar: :any,                 x86_64_linux:  "6dea58b56b76a0f3f08279e231ce864bd0f1bf6b5223ff7da293dc619aa428b8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/wassette-mcp-server")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wassette --version")

    output = shell_output("#{bin}/wassette component list")
    assert_equal "0", JSON.parse(output)["total"].to_s
  end
end