class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "3619c5077338b3aa199a746ab244ff24ee150fb115f71d6e94fdb9c26fcdb209"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f39c43993b3b43ec5056c0a9b24d3dc4b4a5321e5d12f8dfb2f8aab5fd2a426d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f39c43993b3b43ec5056c0a9b24d3dc4b4a5321e5d12f8dfb2f8aab5fd2a426d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f39c43993b3b43ec5056c0a9b24d3dc4b4a5321e5d12f8dfb2f8aab5fd2a426d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0fc45fc6306b86c2a374c35498269ffacc2706fa1a5315b499399726ed0ec21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "168f3636894fcba8844201e6595b14a6bdcf3b8afd6fdcc8d95a49cdcdded4cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe2444b3939c4d30d14708cb46055b2382ce6481e470298052e25ea64c78fff5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/deck"

    generate_completions_from_executable(bin/"deck", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deck --version")
    assert_match "presentation ID is required", shell_output("#{bin}/deck export 2>&1", 1)
  end
end