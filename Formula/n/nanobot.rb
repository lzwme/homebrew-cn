class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.44.tar.gz"
  sha256 "6280db79cbb3d81f97c54cc491f9892f3217fa46f445cd331d895bdedd74692d"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c94913ce4492b73b6b17b2cb0f27ab85785bf961da42bdf6fe77ddf1cb8c8958"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f401c88a81ebfdfb6104fc618cb034fa51664599130c3d3b121f91fb080268f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9bbae1c9b3b56aa920bebd76d91567510d97be545a0702a37acc19642cecbeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "30559558faf404d2c1e13a97d7e7dcc62d91f182496406a53b77632c44caf8ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9600679581e7b15c17dd47ff5e7deaf412219a05738b8199217f5fe22e93dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c32d388fe5be2a92a1c766da657679b6c70e46a03de08ba280eaaf887df7ade8"
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