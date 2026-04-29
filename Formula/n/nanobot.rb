class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.76.tar.gz"
  sha256 "dcd45cb87399c0311b5188ba6462211e8d38f9b754c48850dc1daed4b2147931"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72a279f615b4944c8809a3ac53268a05d674645acaa0fb5bef7945ee777e1ad8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "782545ad73624be3977d5c30f58193e5094fa474f93a7a12a448b8ebb9c2fd1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8426b0748baef212f506e96b6f5ef69ca157aa7ca5a4d0f3f3b3393f2bb79abf"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfbca79f9e6db24072eb217c5c5d5e223ced4ed84db01062af056b54be5d49d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85ea6973774276a0fd17d6db7b4156aa4e7861812c9810e40c02e1d6d84c38c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d2bfaf1c62a3dfb924fa214305ba2cb2e06e4f7daae7587ccc765e566a2229d"
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