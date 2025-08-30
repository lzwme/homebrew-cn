class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.17.3.tar.gz"
  sha256 "c325b4b155efa74ac375bf142e7f2468ef757229ba27b477f4c1917b45dc4ac8"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab74ccdaab243defd7b9eeb6be59e1ae08ab4d80ab27883c646c351d073e24ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab74ccdaab243defd7b9eeb6be59e1ae08ab4d80ab27883c646c351d073e24ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab74ccdaab243defd7b9eeb6be59e1ae08ab4d80ab27883c646c351d073e24ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "7554fa1c12b1fb062ab4936c2b788e2043930b2715a5df39104042efce66628f"
    sha256 cellar: :any_skip_relocation, ventura:       "7554fa1c12b1fb062ab4936c2b788e2043930b2715a5df39104042efce66628f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f123cbae58fb939e462e006223fa43553592f6244b5007d598518b468b4f56f0"
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