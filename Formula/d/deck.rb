class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.24.2.tar.gz"
  sha256 "09af278a2b3ad5802920afe8fe09951334e1f5d09a0c3ae702ccdc5db9563a1a"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3c469b7261082b52fd4b01fa29e5fb90c1cf3d97cf8d8161b0f0ad50747f90cd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3c469b7261082b52fd4b01fa29e5fb90c1cf3d97cf8d8161b0f0ad50747f90cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3c469b7261082b52fd4b01fa29e5fb90c1cf3d97cf8d8161b0f0ad50747f90cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3e6eda697fb0f76b213e697df51ae663099a8459d959eb0c6b5c6c932ff8ec45"
    sha256 cellar: :any,                 x86_64_linux:      "263a0d91c2234854557686340a16e0a4a1f08bc4eea4c92585a284a26702610c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/deck"

    generate_completions_from_executable(bin/"deck", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deck --version")
    assert_match "presentation ID is required", shell_output("#{bin}/deck export 2>&1", 1)
  end
end