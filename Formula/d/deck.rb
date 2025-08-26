class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.17.2.tar.gz"
  sha256 "c128208f9a1babc64e3420f625a65b0b112360afef7666f7e5806daa631b45ce"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e7872557d7d4bf16c565e650f09f5630874283f1eb05a173aca7684c370e730"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e7872557d7d4bf16c565e650f09f5630874283f1eb05a173aca7684c370e730"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e7872557d7d4bf16c565e650f09f5630874283f1eb05a173aca7684c370e730"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0f64c5fd16bdb8e6db679fac43a7e854426cdbef39d30c8ba44c1ede52db901"
    sha256 cellar: :any_skip_relocation, ventura:       "f0f64c5fd16bdb8e6db679fac43a7e854426cdbef39d30c8ba44c1ede52db901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b162e9dbb3222c49f7942cc17c674422c6d86f3f0bca32db61ab5407a95a25c0"
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