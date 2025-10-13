class Tmuxai < Formula
  desc "AI-powered, non-intrusive terminal assistant"
  homepage "https://tmuxai.dev/"
  url "https://ghfast.top/https://github.com/alvinunreal/tmuxai/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "fa23d9cc1dfad0cd549495dab11c7a1823a85d27b302db219c23053d618b80b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "114686cb21dabc771336725480457ac2c35926c3f33bf18ee7cc937abef22e81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "114686cb21dabc771336725480457ac2c35926c3f33bf18ee7cc937abef22e81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "114686cb21dabc771336725480457ac2c35926c3f33bf18ee7cc937abef22e81"
    sha256 cellar: :any_skip_relocation, sonoma:        "623f150a1a7c67cf8013480286196e0c6668edc74b3ec96c25717be992028a54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "603b64650db07fec02e58a896f7bc96fcb5ebeb042bdc4d28f7694d88ceb3e6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a16837a303e37c8eab3db457c7dc64b8dbbc1eb8d18e0178ecbd26823eaace16"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ldflags = "-s -w -X github.com/alvinunreal/tmuxai/internal.Version=v#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxai -v")

    output = shell_output("#{bin}/tmuxai -f nonexistent 2>&1", 1)
    assert_match "Error reading task file", output
  end
end