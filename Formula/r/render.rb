class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://ghfast.top/https://github.com/render-oss/cli/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "2e7b141769559272b7d7adc2d9cc782803ef128a5861fb59eccb3de836b52a6f"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40fd6e5af8e77ccefc278f3f595b4545f5da9b98d3344765867e1d4ff750984a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40fd6e5af8e77ccefc278f3f595b4545f5da9b98d3344765867e1d4ff750984a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40fd6e5af8e77ccefc278f3f595b4545f5da9b98d3344765867e1d4ff750984a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f4af4bfb3df89eadf03219ce96b33547db3d656ea4294b67c8fe7e5cf6acd0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34e4fed825ae876b5ded0b745374e6732f7372faef3f0bcc3840ec81c991ba68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "427ee7c17c59dcbc9fd130feb67bd8c3c9632afdce27901cbdcb1290a7eb3e8e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/render-oss/cli/pkg/cfg.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/render --version")

    output = shell_output("#{bin}/render services -o json 2>&1", 1)
    assert_match "Error: no workspace set. Use `render workspace set` to set a workspace", output
  end
end