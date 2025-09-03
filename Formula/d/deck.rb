class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "c8ced434a3ce10384e231a585f3c744f6041312f11ef4b12884f84030fceec9e"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e522839fcdfeded92ec3d72e1d4e58c078a89a243c32a83231f0e92d95183eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e522839fcdfeded92ec3d72e1d4e58c078a89a243c32a83231f0e92d95183eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e522839fcdfeded92ec3d72e1d4e58c078a89a243c32a83231f0e92d95183eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b6846127c3b2707e83fe9b84f2c1af1498dd753f12bb648b841a71039c7d441"
    sha256 cellar: :any_skip_relocation, ventura:       "9b6846127c3b2707e83fe9b84f2c1af1498dd753f12bb648b841a71039c7d441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bece4b7db963df57ae98916be73cc4d274c40afda9048662c5b26517a64a71c"
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