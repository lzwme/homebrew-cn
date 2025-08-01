class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "7136eba6db276237898099a38f62e6094b205be34748a539d6a6f8e95c19b6c5"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fee021bc25c9e4b11b96eb32643b65bd0264121651c132c36246a6acc36f992"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fee021bc25c9e4b11b96eb32643b65bd0264121651c132c36246a6acc36f992"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fee021bc25c9e4b11b96eb32643b65bd0264121651c132c36246a6acc36f992"
    sha256 cellar: :any_skip_relocation, sonoma:        "43771b2949a9290dfe45c8880b54983a3c82a6d6341f755567726bd05eaa8d74"
    sha256 cellar: :any_skip_relocation, ventura:       "43771b2949a9290dfe45c8880b54983a3c82a6d6341f755567726bd05eaa8d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbdd67b70dfc709288fcd44f804ad38f481df4e1f37a288ad7736116f47ba6d6"
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