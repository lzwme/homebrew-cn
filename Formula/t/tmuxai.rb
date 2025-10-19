class Tmuxai < Formula
  desc "AI-powered, non-intrusive terminal assistant"
  homepage "https://tmuxai.dev/"
  url "https://ghfast.top/https://github.com/alvinunreal/tmuxai/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "d73abd0d6b99a0f3cc7f54ca9ec1bd098b382c775abea5534c94bb07a984d138"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf1120709aa73326f1ff974578da28ee4309f1d4950776d8a5ea634b6376833a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf1120709aa73326f1ff974578da28ee4309f1d4950776d8a5ea634b6376833a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf1120709aa73326f1ff974578da28ee4309f1d4950776d8a5ea634b6376833a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6f3a2fc670bb06d24e60a13f3e8d91f4c5b0ad2b3d84778511500330e91a97d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b103eb48aa582abe60510b6d5c8b9d00629617bba31ab64dbbdee88062666aae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22804724bcbae5e8b9486c2f714165ed98613a5adc16edb84e3bfa992e8291d3"
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