class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "bfd3312eae37b010058cc0f1b8c56368934e764b9e7d4e0397a5e49e9b24767b"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f16f06494e859670603182cfc3da01af6a7d03a0c673d113142257b0cbd06f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f16f06494e859670603182cfc3da01af6a7d03a0c673d113142257b0cbd06f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f16f06494e859670603182cfc3da01af6a7d03a0c673d113142257b0cbd06f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "76fb1a536eabc9ae0623a9e463f10c168d2f76a983db45e1402d7487534d19a8"
    sha256 cellar: :any_skip_relocation, ventura:       "76fb1a536eabc9ae0623a9e463f10c168d2f76a983db45e1402d7487534d19a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8bf62cd15be93b84ff74e1b4714d7f57ba543eef0fc88f23b045510239a65ef"
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