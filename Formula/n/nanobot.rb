class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.39.tar.gz"
  sha256 "54ec89d1715fdebbf21c42ec3e170d401eb8b5e89dd0a367a1bbb17b51826906"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b187de8e56996aff571b25872d80d713cf7a232c5750c4565a6e32ac6cd2e714"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6da264f87dc78390c5a6cfe5184f65f91ab13fa56d2d3fd78aa7bc6a66cc24c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55324b3cef0e01683111adf732d27c1d4d1930ff092b21c831b7f0ef66a23d77"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4e299dd43097c2b5a9083fc060339ad3feed8919b66191c290a967bd22097bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "706b76a594e2ae24977c1c734dd787d7db56eac3007c0a16f5adffd87ee12b53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a85c6665d86a53527d71ea997a0cfeef2e5ca90ff27cd4904bf9aa7226954175"
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