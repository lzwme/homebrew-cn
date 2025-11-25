class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.38.tar.gz"
  sha256 "39675a9c49078cd0d812d3bbac2721c3e79ca9245d34fe91bad4c64208b29d26"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7390b606fe6b7adfb6030543060b54c858ce71e8cd7bf8a518586e838a550c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6e1025e2b97350e8da0c1f66985e975a46eb4edaabc74d22c8057b1b846ef9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19af9d68b08aa70db631c69d557b8b3b5c6d008d1fe17e5b2a22767245729dd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "646a88f6a2ce73fec45cd6c37b7aaa386d40271c1017a628e8906b2286f2299a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddab36c6033dc1438348a07d46f3eec74d69b322b6acc44e9186ccb44218ab63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e48dca5320c58adb412d555e9486e28daf04e621c3ce28bfcb1cfa112197a0f"
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