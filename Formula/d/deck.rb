class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.21.4.tar.gz"
  sha256 "000bb05db07afde21eb61ee830e8e6c33e12aeb5481c6c203243e134d3d151f9"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebb74cf988c4389367e628c97f00e674f0aca1dc9ae95d3dfc6bed45e52c0453"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebb74cf988c4389367e628c97f00e674f0aca1dc9ae95d3dfc6bed45e52c0453"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebb74cf988c4389367e628c97f00e674f0aca1dc9ae95d3dfc6bed45e52c0453"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a4c65c9c5aa63862c932030222e7690703db4049e9bdf7347d22915cfcbf238"
    sha256 cellar: :any_skip_relocation, ventura:       "0a4c65c9c5aa63862c932030222e7690703db4049e9bdf7347d22915cfcbf238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89b4bc9e2ea251ed61296c04adefb78a09af457fe7d0aa36625fdf555b1d9d57"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/deck"

    generate_completions_from_executable(bin/"deck", "completion", shells: [:zsh, :bash, :fish])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deck --version")
    assert_match "presentation ID is required", shell_output("#{bin}/deck export 2>&1", 1)
  end
end