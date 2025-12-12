class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.45.tar.gz"
  sha256 "e5eb14e62df31d1a4687f78227316f3fdc0fbab83ebb2c9e8fe1326a6673be35"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "097b48daa4c25374c66b0e48c767485532731936d707ec50357321daf5aba8e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b394b8523e9ee45f170de5421cc6e048e48f0107d7b021d9ea168493cb31337c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd5f109cffef688cb585e73969c639359ebc80db268636ded0525065393f1f9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b914d8a02f7bb382b305951de6132270132e652fa2721a92e4d6a7705e7013a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f69bf488508854c4e8a89d48199ffd68f5e1f03d2c6b0d2f26a5509779cdff77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec85901f3203ff5074b879929e1ad8d27fd90f5f581dc4fbccc981d5be35f9f0"
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