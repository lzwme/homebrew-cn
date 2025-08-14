class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "4628d49a0bb62c2eb62634584025f021391d873861bab41ab08d7c9c4c5955f1"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfa257925f67a0c11c32978cf6726d19760bbedbb1a8d3962514db0677be9c63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfa257925f67a0c11c32978cf6726d19760bbedbb1a8d3962514db0677be9c63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bfa257925f67a0c11c32978cf6726d19760bbedbb1a8d3962514db0677be9c63"
    sha256 cellar: :any_skip_relocation, sonoma:        "a00a1d341f5299a1b84f72f77b98cce02e2c6eb67140b8e0079c8374698b5a2f"
    sha256 cellar: :any_skip_relocation, ventura:       "a00a1d341f5299a1b84f72f77b98cce02e2c6eb67140b8e0079c8374698b5a2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e7647649245969e45244773aaf967689fb82df2949748866704dafc5dd76dfc"
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