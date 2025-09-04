class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "47c84e5f19f459d8b8c47992e8a30016a8fcd6dd7f0872807cab1c54b71903c0"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3368870893e82fde882cf491034bf0f2020496ab5e8e2445d8f4d2d536843253"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3368870893e82fde882cf491034bf0f2020496ab5e8e2445d8f4d2d536843253"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3368870893e82fde882cf491034bf0f2020496ab5e8e2445d8f4d2d536843253"
    sha256 cellar: :any_skip_relocation, sonoma:        "e97ffae747b9f8db5e43064a6fcf19e4f2ba2357b0e1852aa9343f352ea275e4"
    sha256 cellar: :any_skip_relocation, ventura:       "e97ffae747b9f8db5e43064a6fcf19e4f2ba2357b0e1852aa9343f352ea275e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cebf4e2de7ea372161f412fcb61adbf04a5b75dda65ab85a8f6474085a4698e2"
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