class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "3104f47a2ab0aacc6f8c9d30933247f02dffa9aee577e43afaad7223d0581e89"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e5e7351dbe46d196915b23afd1b9f56849c62d85866da9902d0af4f9dbda9c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e5e7351dbe46d196915b23afd1b9f56849c62d85866da9902d0af4f9dbda9c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e5e7351dbe46d196915b23afd1b9f56849c62d85866da9902d0af4f9dbda9c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4ccccb03aff8e6600b84e92cea1b2bdbac367757d689ba98664aecf4917b613"
    sha256 cellar: :any_skip_relocation, ventura:       "a4ccccb03aff8e6600b84e92cea1b2bdbac367757d689ba98664aecf4917b613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4a940c72ccfaebd02bce30ff01419c1f8cda6288c28e6d8152e8703973b0e4b"
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