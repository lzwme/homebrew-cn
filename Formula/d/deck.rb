class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "ee6039b13562efc1be552399f38d1f5660b9cc84aedc35cdda8e02144d99ee6a"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a33151a3b6e922984e60ab96b5767cf28fa322c478f40da2a5a8fc459616359"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a33151a3b6e922984e60ab96b5767cf28fa322c478f40da2a5a8fc459616359"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a33151a3b6e922984e60ab96b5767cf28fa322c478f40da2a5a8fc459616359"
    sha256 cellar: :any_skip_relocation, sonoma:        "035ff04f3d7b0c22597574f7d870a37749bcf8a0a88b524c22964fa55bce9367"
    sha256 cellar: :any_skip_relocation, ventura:       "035ff04f3d7b0c22597574f7d870a37749bcf8a0a88b524c22964fa55bce9367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de78c6be20b9b1d91544bf2320f8255a84b8802df8dd8f934ea8f55fe1129da0"
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