class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.51.tar.gz"
  sha256 "1a9ff59d7d0356df132ab01f5ccebb9663fc9d1725b122b288e6625ef39f8568"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bce361d8d70c6cc8ff1c2c83983352c31b9162ed5bcb21fc1044a9b91ad48cee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bce361d8d70c6cc8ff1c2c83983352c31b9162ed5bcb21fc1044a9b91ad48cee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bce361d8d70c6cc8ff1c2c83983352c31b9162ed5bcb21fc1044a9b91ad48cee"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3ae00a5fab8ef08151b67af770a8cc4455e9e1a506299d0d3f5818c264eaff2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cc8e38e424a46938cf779d605602be47f5f08f540d8a009aca8aeca9545a06a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03e36842491e1b4af63c59d75fd1fec05bfe114b3a992e00b16dc88e5a5481d5"
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