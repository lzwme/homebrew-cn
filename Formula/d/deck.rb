class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "6efda3dd05d2ff1d2ba0705c4d575cf35fc1d6d596ac2dc029a242f14c8d5f72"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dca80b570e848b7fa693a3261065c137b1c4c797e82b28457489b82e5273649f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dca80b570e848b7fa693a3261065c137b1c4c797e82b28457489b82e5273649f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dca80b570e848b7fa693a3261065c137b1c4c797e82b28457489b82e5273649f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5f93ccc67fd50bdd66b209fa3ffbdd9d7ab5d53418eb0006fd0424b906d6023"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "345ad8412416161cf76fc4c0c5008069f071cc173baf42915b084b76d975b38b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d1a7d134f4b93a2e1f999fc0301c8b63d78d09fccda682f669250776c027649"
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