class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.49.tar.gz"
  sha256 "23fe611b9c6fbc1a920ace9b276a25d225afab12d0a10eb130793d31ee934761"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "443205e01209dc98837d85afb39f6d5a0cc5ead0096bcb2f4bd926d74016a9d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "443205e01209dc98837d85afb39f6d5a0cc5ead0096bcb2f4bd926d74016a9d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "443205e01209dc98837d85afb39f6d5a0cc5ead0096bcb2f4bd926d74016a9d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "35b487a53675723119cfc1c50e6f3458ccb3636d393e4ae76db481da051b9169"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42ae822720a5defdbe391b3f8fce3407bbdb007a27122e90c10e2b96392b7de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ac363ced7f0e85ea2137bf863a3d7b773634763635a44d0517c92ef912884a8"
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