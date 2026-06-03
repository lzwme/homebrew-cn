class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://ghfast.top/https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.4.tar.gz"
  sha256 "481a346985f5428b6e5dc91b7eede9e88cb7ab6bd8582de641ada21ff4980335"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce457355b743fcfe87e5ec1ff69619e9206473bf89466f091a141a17f605dfa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c85add891a267ca2d5d0984e32723525ba1acc224f896a7f7d69ab6eec2ea4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65e74494b48e57dba7a6d6dfaf323061c08bc5d322b3cb270c16baa88444d15e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a8f9869b6f90a2f104f2d06bf6e015dd0828d8d22b8f94f6918e72a04567e02"
    sha256 cellar: :any,                 arm64_linux:   "16fd9ee3c1cd405d83d65bf7ba21f35e7cd9451af2c54fa838ae650208bc0a00"
    sha256 cellar: :any,                 x86_64_linux:  "5fdd45855be2aafa4b533d5c74c5db1204937c6474a759642005c86c45fc34ce"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end