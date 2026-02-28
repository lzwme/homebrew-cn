class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.56.tar.gz"
  sha256 "12bb3234b497d54d88f18a74c6bbc936b5da83af620c94d09b08746bcac9a00e"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a4ae2fd795284994380c7ccf55ed46a39903af56ef84244798a674a97ed2f66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a4ae2fd795284994380c7ccf55ed46a39903af56ef84244798a674a97ed2f66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a4ae2fd795284994380c7ccf55ed46a39903af56ef84244798a674a97ed2f66"
    sha256 cellar: :any_skip_relocation, sonoma:        "68fe60c70a022119e6e563d78af7433f2f5c1653ec218f7b2b5299e195042c8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9569278837bf1cb51d6f9a96f5754d8077e013f401f1f9e386e5b2766cf09b72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22e6622e6d49438d96a6863d6bd47758302c4c1844c0f5ba6f45d9565e7e9a1e"
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