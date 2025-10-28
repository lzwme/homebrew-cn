class Tmuxai < Formula
  desc "AI-powered, non-intrusive terminal assistant"
  homepage "https://tmuxai.dev/"
  url "https://ghfast.top/https://github.com/alvinunreal/tmuxai/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "392ac5107c736d1f85c6a82dd42f71bb80b702908ce794f953978aafb7347fe9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bda04861393afd566c72a0c4ec640f5e46d5aedd429e7edc602d5e71f86e173c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bda04861393afd566c72a0c4ec640f5e46d5aedd429e7edc602d5e71f86e173c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bda04861393afd566c72a0c4ec640f5e46d5aedd429e7edc602d5e71f86e173c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9388e0a68084df6e31ede0e85004378a62e4345e36f6a4bc5eb8e32f8cf7afcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "286dce12746627d345383484f4230a57546849cd7584d1d91e87eca5782636ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ba6480640cf386f4d8e6ff00ea4f399572b5796c00720fc0156caa29950db08"
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