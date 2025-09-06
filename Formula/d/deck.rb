class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.21.3.tar.gz"
  sha256 "f37a8909682518c3609730ee347a2bf7e704c9eb101133c615ab9bb371df9641"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d80cabaa664a932fb03ed20fe2b5d2d231d05d5f5ab0b955c2ab0b57ea52ec1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d80cabaa664a932fb03ed20fe2b5d2d231d05d5f5ab0b955c2ab0b57ea52ec1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d80cabaa664a932fb03ed20fe2b5d2d231d05d5f5ab0b955c2ab0b57ea52ec1"
    sha256 cellar: :any_skip_relocation, sonoma:        "65f8e30d776e9736a3cd0975366f39580f6ddd06fa1fb58bbf1e383ad76a8773"
    sha256 cellar: :any_skip_relocation, ventura:       "65f8e30d776e9736a3cd0975366f39580f6ddd06fa1fb58bbf1e383ad76a8773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cddbebd0bcd314f03c5fa3e7c98d0d75f4aef4dfa89c31e2b1ff8b8316a4f2f6"
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