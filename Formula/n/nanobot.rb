class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/obot-platform/nanobot/archive/refs/tags/v0.0.82.tar.gz"
  sha256 "b21788267790a477695a4bbfc061f758652dd0227119f6da876ae885aeb15471"
  license "Apache-2.0"
  head "https://github.com/obot-platform/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72c99b9cf866e2424ba2b910998585bd7cefc01f5377a046b3421dba46414056"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4658fc07d4c7df889f84e668f4115fb73b6c02b2e8dba79617b9540049e7f11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f42eee95bf3a05be4282ecf0aba8c4fc8df91888f2bfafd724cfbbd33e3d9b0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d457310c6989431cdca839d5ceadaf0b04ee1e7e725f755e08d331501e3fb09b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75f86c0742e75f4b6e5ca37b8435db18eb028ab4e8f7ad8cb804c29365fa18e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1439bf83c3e22a66a0d227f8fec9237a5a2b43845cef68dd08c43fd643cf54cf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/obot-platform/nanobot/pkg/version.Tag=v#{version}
      -X github.com/obot-platform/nanobot/pkg/version.BaseImage=ghcr.io/nanobot-ai/nanobot:v#{version}
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