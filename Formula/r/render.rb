class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://ghfast.top/https://github.com/render-oss/cli/archive/refs/tags/v2.26.0.tar.gz"
  sha256 "f1934ac179570a37ef2986c0b792eb8b3bfaf97ae2f2d36d112cc2282a71fa22"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af5cadb6ba903a5aa4a0746939435229ce8281a69d06f4ff5436e43f9a819593"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af5cadb6ba903a5aa4a0746939435229ce8281a69d06f4ff5436e43f9a819593"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af5cadb6ba903a5aa4a0746939435229ce8281a69d06f4ff5436e43f9a819593"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5de0677998520b4ee6dacf29f4fe2be2093d78c1be65148e1f1b8f78fa48333"
    sha256 cellar: :any,                 x86_64_linux:  "e74c119eb757d1dc2ea60b9a79844e51f9b0cf51bf4cc17b132617ff3147ca50"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/render-oss/cli/pkg/cfg.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/render --version")

    output = shell_output("#{bin}/render services -o json 2>&1", 1)
    assert_match "Error: no workspace set. Use `render workspace set` to set a workspace", output
  end
end