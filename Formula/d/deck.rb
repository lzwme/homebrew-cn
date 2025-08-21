class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "4927e3d002d2dc1522c4c9363e40a347b22c48f51f33321d179baf9ead464e00"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ed317d782100e5453cbf315fa7b4513bbe56cd7452cf39755d6859dab14f662"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ed317d782100e5453cbf315fa7b4513bbe56cd7452cf39755d6859dab14f662"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ed317d782100e5453cbf315fa7b4513bbe56cd7452cf39755d6859dab14f662"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6ae8ccd2e3c3e802d27027702a573e36728e0a00b7f2bfce2dcc03e19682a06"
    sha256 cellar: :any_skip_relocation, ventura:       "f6ae8ccd2e3c3e802d27027702a573e36728e0a00b7f2bfce2dcc03e19682a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f673cc8e8c544d14b3e8a2967f4efd9f8b3658a8fcab46711c94c6129f1d2890"
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