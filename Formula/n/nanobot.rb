class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.67.tar.gz"
  sha256 "c331b8175e47bdad6946e17aa4cf880bfd4ad59a016110b6f3909e54319b9348"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d792a7fbb6c467c7f0e975131115ffe8e0451915bb3a31a7988ce48fd6acf81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3ae64801d26feb5e6fa34eddb41f4bd0fee6cee9756e584b9fdbca59824f3a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0bc6b33762b783e89351249ca46cfc588ed38184ed9e2df0e3febcbd3d92df6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a6785b776eecdc380c69ba6ab262359b40a8c16ba2889338bb50b3285e07074"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3f3e3b91aa2d588fee2dd249b42217cbc3b70216ed0df188343ee4f5489225b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "967438993a72d05646e4942941b1485d840c0f4563506112db07368ee545408b"
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