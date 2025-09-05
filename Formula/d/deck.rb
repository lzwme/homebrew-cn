class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "c0950bd2d7d62537a77d932a3a0e6080219f95814b1665907d6d35e47cb14047"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9923191aa7568fdfa6f9cb98abc3fe71ee449ce00033094553cdb94c1dcafc4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9923191aa7568fdfa6f9cb98abc3fe71ee449ce00033094553cdb94c1dcafc4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9923191aa7568fdfa6f9cb98abc3fe71ee449ce00033094553cdb94c1dcafc4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "debc86722c4f251df12d5a924244a5e97b661e40df043c4ae11bc3c595f8bc46"
    sha256 cellar: :any_skip_relocation, ventura:       "debc86722c4f251df12d5a924244a5e97b661e40df043c4ae11bc3c595f8bc46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c92417f1c607a431da3806a184e7728cafd2f60493a44f3a40c6e1a5752141e1"
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