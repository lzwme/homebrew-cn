class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.42.tar.gz"
  sha256 "830489e8d5f5758dcd1d7a8e76fbbda435403aa0bd8aeb01cf5ad86a045d4d7a"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40ef262062a634a7f5ea2842bcc469c81929572e52c8908335ac1fc7feeed81a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "971919f2589dcecada97b84dc0a41777ac9c373041a43ba90758730043a5539f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01a3c4fa5eb92226917c939ed30354d61df2e3f3245b0deecdd40f351f04dfab"
    sha256 cellar: :any_skip_relocation, sonoma:        "041e7ad2e7326ad8d9b90e86971470a2ba827e2dfd762881899c9045c1936438"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "546c1cc5062985d582b1caa91badad07b42b27323c30caf0764b0fd85ead1547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fd00652429eb271929a8779166cdc55d7aef82473f09236a18a1d06e46098a0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nanobot-ai/nanobot/pkg/version.Tag=v#{version}
      -X github.com/nanobot-ai/nanobot/pkg/version.BaseImage=ghcr.io/nanobot-ai/nanobot:v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanobot --version")

    pid = spawn bin/"nanobot", "run"
    sleep 1
    assert_path_exists testpath/"nanobot.db"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end