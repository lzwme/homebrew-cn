class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://ghfast.top/https://github.com/render-oss/cli/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "ce53d977dbdfd69843723796470c224fd39182fac3932cb099e3b89d2e352519"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36280e1230aa803f1ce0f4ecef4eb54b055f254aff5c12b5599daad19e399944"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36280e1230aa803f1ce0f4ecef4eb54b055f254aff5c12b5599daad19e399944"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36280e1230aa803f1ce0f4ecef4eb54b055f254aff5c12b5599daad19e399944"
    sha256 cellar: :any_skip_relocation, sonoma:        "79ac24c7cdcc9ff2751dd62ad7135c8a08833850ed4139adf80846956ea80f90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b7198f5f4f87b85942fac1035547d8aac8a383b5e61e5c269c23ceda076409d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50ea45ee7314adc021960da56a3ad6fba72a14d3160b347a8c169cf8abfe4be6"
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