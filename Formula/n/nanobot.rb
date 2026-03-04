class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.58.tar.gz"
  sha256 "1d8c3ff1141ad4b7a0c7edebc603a11b41b68190e499229c4e3a435e0d71b5f4"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "407a9c1fb5256f98a8092bbdd276cf22de1c900d872245c2611a8267bc0fcf8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "407a9c1fb5256f98a8092bbdd276cf22de1c900d872245c2611a8267bc0fcf8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "407a9c1fb5256f98a8092bbdd276cf22de1c900d872245c2611a8267bc0fcf8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc7c1eb99de31b1fcdad4360f82cd98b142f8e5df8124593a9315137cb215a9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33767e9579efee179865eee7407490827d3295959d6bd05326baf3f3b2d4ac50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "957c9f7ecade288ad1cd253e10f012131ec4b409e1e4948e65e7035eeead8d85"
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