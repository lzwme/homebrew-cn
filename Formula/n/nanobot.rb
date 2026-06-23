class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/obot-platform/nanobot/archive/refs/tags/v0.0.86.tar.gz"
  sha256 "1eb5adb37dac7a75d445a96008736fac03afe199825ed1bd91bb417d34884883"
  license "Apache-2.0"
  head "https://github.com/obot-platform/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3056488804beedc960d3779788707a73f38d5fd5e8938e41d585095e94d8814"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dfd0b50d5ae404734ca0b0b67af22b22ba1e45e825a149fa7af00c32d812fa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95ea57f56c822df6b081828b9f0b1659985aeb17d0e496d91c6f24d2425f04a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d59b323f6159fb15cc5c61eae529011fd4d044d9b2f9d35a536adfd9216e7d27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de1e4a770f64a30fea4b6b623788963647c4f9e63864ee213b77997a0525288c"
    sha256 cellar: :any,                 x86_64_linux:  "ec518cbdd3878a0b4a2f3f56abdeb9200470331f7f4d662147becd767ff85a13"
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