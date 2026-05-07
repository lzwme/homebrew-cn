class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.78.tar.gz"
  sha256 "59e4b88b75bbf23a6e49e1d21d0da6097ff90c9766fb7e047baab6ba0be94a9a"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25012fb9ddbd06c25e4e21d259088b5a99d3f7e52b0e7911ddae7f5befc6a241"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44dc5bc6ed3025ec7d559840044722ab57a27c75cf82ce65ed74b5294b5ce2e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa5d5ed5edc220579ab945070e831e268c496fc0e9feba60764d199f221e984d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b49ac9a2e5fede76cb3b47b497029aae81b7af2df89a2d96e0db0167129051a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "394a7f46ce3a1c59ee6159b8c39c517b499465cbbc04db98e7eb594482838ebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5efaf71a2d9e70ce283fcb9bd5c4ea7add9ed472492892e805c293b3602ac491"
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