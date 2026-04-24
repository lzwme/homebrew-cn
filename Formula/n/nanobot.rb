class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.72.tar.gz"
  sha256 "0518b9a8f60507a62739e8812713f0e1136c3dfcc6453d2f25d5e7b66f3c86d4"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9508a6a317de27942d9d81709c6a824d35d7a380ee99c7e68ee005bd5b335c15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c38744f72154715aa0d57f287e5cabb39634e0a6588c8d53ebdfc5a8adc65bc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c75a2a8a6e216b808abc1c682b83e948be787f1268bd4e5bf07e804e7ad2ef56"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d0a7b3846efbf27d7f88769c55d53fbaaf529fe3c93aae86a40bea5dddff2d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fd0c90a78e758ff78ce5393055e592cbb54597bc82756e7534cba3fd6abbd07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d7af291de4af36cb7b97ca70b877c3ebf325527d1761fac22b6651b5ed75f03"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nanobot-ai/nanobot/pkg/version.Tag=v#{version}
      -X github.com/nanobot-ai/nanobot/pkg/version.BaseImage=ghcr.io/nanobot-ai/nanobot:v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"nanobot", shell_parameter_format: :cobra)
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