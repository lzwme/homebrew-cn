class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://ghproxy.com/https://github.com/mineiros-io/terramate/archive/refs/tags/v0.2.15.tar.gz"
  sha256 "59ed3bc7444009c946bf636b94690dfac7217e497b06b289703f14a641bc067d"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acdc836e4eb88b94eb23022ee237770f76430bbec6ea543d64c07f4ce1472460"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acdc836e4eb88b94eb23022ee237770f76430bbec6ea543d64c07f4ce1472460"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acdc836e4eb88b94eb23022ee237770f76430bbec6ea543d64c07f4ce1472460"
    sha256 cellar: :any_skip_relocation, ventura:        "faefea46ab46193f1abf250c7dc5ebb9ff2bf3ad1bafec791eb6806c258aa486"
    sha256 cellar: :any_skip_relocation, monterey:       "faefea46ab46193f1abf250c7dc5ebb9ff2bf3ad1bafec791eb6806c258aa486"
    sha256 cellar: :any_skip_relocation, big_sur:        "faefea46ab46193f1abf250c7dc5ebb9ff2bf3ad1bafec791eb6806c258aa486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ab103f62975455d3871120208acb564974821fd2e736d042d615488bb49605d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end