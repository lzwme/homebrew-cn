class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "28171443ea342fc1da645be8b61f67d1a571ccd0ca16b8ca582f56ffc3b3092f"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6f1cb86137d15b338a293f14400ec27d8d910605368681b4df08931bdf8a692"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6f1cb86137d15b338a293f14400ec27d8d910605368681b4df08931bdf8a692"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6f1cb86137d15b338a293f14400ec27d8d910605368681b4df08931bdf8a692"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d2b5d971ae9648ea4ebd2de2ef933ff41a5f5badaaac34be26bc37f0ac0ed4c"
    sha256 cellar: :any_skip_relocation, ventura:       "8d2b5d971ae9648ea4ebd2de2ef933ff41a5f5badaaac34be26bc37f0ac0ed4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9313edab557e5aa647e02b3100cbe67653f5b36776758fa7218d2bbf3d1e3d7"
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