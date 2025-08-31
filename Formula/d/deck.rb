class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "553ef82f07dfd4c55d061ad5e9ad4dcf675a4eadeb986105445edecc7b07994e"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "674c9d3589601ff41be04a501f4a14f749d030266fbf44b0a9f4bb1a81d93c03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "674c9d3589601ff41be04a501f4a14f749d030266fbf44b0a9f4bb1a81d93c03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "674c9d3589601ff41be04a501f4a14f749d030266fbf44b0a9f4bb1a81d93c03"
    sha256 cellar: :any_skip_relocation, sonoma:        "b34df94cd5dbe7eccb9864430bbb8991f6397f355c3cb28ed2bebbd0b8aac922"
    sha256 cellar: :any_skip_relocation, ventura:       "b34df94cd5dbe7eccb9864430bbb8991f6397f355c3cb28ed2bebbd0b8aac922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5daee7ea4221d70499b4ce45ddb05584bce85c55b02b49469b1540d132612496"
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