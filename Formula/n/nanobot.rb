class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.40.tar.gz"
  sha256 "13d4cdbc8ea575856ab3ba5061a52fabcd920f22f1af05aeb27bee9df1ae68df"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ace024c5fd8145ae5ccfb476b5d031c4d0f806bc1e05e6aa679cead6a23e067"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67f1a816c7cc901a1e04d117b1ca8adecccf9690f1f394bdd6f31f5df1966e12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a458c3bec628eebfb913b4e62008f98ae5c039093165581b3e367eed43663ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "4dca308621a089b87a495ad5b6677839973e08663b0ebad8f1bb78d1cc081fdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd5a6b2b883dacb61698314ec1fed6efce4db0688715917db493f7d5d93b4099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25c8c59e267bdc74f4fc25808e41eaaf0728efc2980f171ba58307c244904cf7"
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