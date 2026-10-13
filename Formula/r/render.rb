class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://ghfast.top/https://github.com/render-oss/cli/archive/refs/tags/v2.29.0.tar.gz"
  sha256 "ad9303a93a2e61130eb3b69d2afedab9cab89a904ce5a3947f3c4338e72e4484"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "96a7ce7e946f7434d5a9912fdbe28a7177d506aa2fc0fe3be47e94125c1fe1dc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "96a7ce7e946f7434d5a9912fdbe28a7177d506aa2fc0fe3be47e94125c1fe1dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "96a7ce7e946f7434d5a9912fdbe28a7177d506aa2fc0fe3be47e94125c1fe1dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f431d62d56474bbdf2c519c0c3b946725b7f1acdc51a167ed89453ae72942cfe"
    sha256 cellar: :any,                 x86_64_linux:      "ad59906786457186f9e50bd67ad97889ee94793191cc6c58ab8bddb9aa966aba"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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