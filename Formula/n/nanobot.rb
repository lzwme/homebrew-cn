class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/obot-platform/nanobot/archive/refs/tags/v0.0.89.tar.gz"
  sha256 "ae754171226af874e42468b902d1571ff1fc25eb2a6819781f85836ceff8000b"
  license "Apache-2.0"
  head "https://github.com/obot-platform/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81a25e33eb0c3587c864eb64917244addffd585e80200c2da06938b51c3fee9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef31dd30397b54f4ecc8341f374cd21f9e94176fed38b3275bd302bd90eef04e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e39986ae6bfd9958e282bdbf7be5a9cc761cdf36801e10adde44b7c0a976cf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "936a34d7333af93e3dcc57f71bbd8f345f2cb8ed7f32dc70a53c537f1b3546ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51140f76471a908bdaabc2886ef2d77069838e8b7471614d4bc033bcc3e7f57a"
    sha256 cellar: :any,                 x86_64_linux:  "e68c522d70dcc55d7185e11a8036ea34a5c9bc2356191d6efb49240631fd5480"
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