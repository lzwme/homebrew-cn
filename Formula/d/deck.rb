class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.19.2.tar.gz"
  sha256 "ec6b7b3b0f75d42c8228827823e3bc7885a7344013f6ee102db2394701b42e24"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47c556691d0fff6eac62c2abe856b57b65b9ac544274a00b24c084cd439f7bd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47c556691d0fff6eac62c2abe856b57b65b9ac544274a00b24c084cd439f7bd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47c556691d0fff6eac62c2abe856b57b65b9ac544274a00b24c084cd439f7bd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b46c0ebc4abd2f59a9b7c01235ac846418b029f3ee6ba89efde9dc2f912306f5"
    sha256 cellar: :any_skip_relocation, ventura:       "b46c0ebc4abd2f59a9b7c01235ac846418b029f3ee6ba89efde9dc2f912306f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c603aab9f5e8611c4d45f11c0892b1a74c6d3b2ae44cf37e081a4a8a46a79ac6"
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