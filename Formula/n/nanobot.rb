class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.46.tar.gz"
  sha256 "f21d248204ee5a3204dac83030dc26fafb630b28e7c13a68da6c05e15d282660"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44b604cbc72cb8661f5fd0010dd3d357096f617ecfef2f7c3b07c07755f3bf39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "984df816be566ba80fe6f4fba9b6587c866a7faef417a9a158c456fb83203511"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a8334a09223a4344f5816dd1cf5a1669e3dd37797f316a57e2cbe4f8d025d5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c08efd3cd700b73e1fc8f827d4f56c1f9be09bee69cc708ad5124c8f73357a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fbe2feb480157c65d4b1c253bedaa9a1b7ed3ac905ea7f24a97d5be3f723fdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dbd1e6fc6774e713d099be1b8396a8da96ceffec27c6437b9aa6481b605a705"
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