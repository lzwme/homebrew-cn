class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.70.tar.gz"
  sha256 "9ea98883e91b71d2d78d86c299fc5b92264e4270b14ec51e1a2f024bbea013ce"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c463e78e39c9e31efd5c00a72554533e0d119d268f5525db63277365f69a873b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5738edd8ead1571b258eeba983bd7d319c41251ebc7451a385221aa6b75f4610"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "685c250a82809b844cca3d1ad8f30e59deb843c137c8cd1807bb0de4fc69b7dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4907bde7c81ba8136afab18be8b2f3d8507faa3afa61359ce661c248de014b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "192aee63a20f145cc6f78ab0f4030d35eae975a7bc92f81525c0a094e71b4ca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92060d3f1f8e3e7c511711382359273ff6aa2bd37bdd66fac54d2e58b129b413"
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