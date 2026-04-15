class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.66.tar.gz"
  sha256 "e7920c474c2bad938bd34e55ae81b469df91cbf75d58e0978b0d0f7a41daffba"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bf0b5e4ea160e28e8a1d8e1a585fb82c5a980dd23c4f2595e04e3234107144f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c09585190e3bb08248c2450e49519d7d61b9f8231c9e609ac88e2a060d0fda50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f27fb568c94f84dfd766d1917d9a3c7b6c57a943f982b06b669e4bebb3963c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd3be0d1fb72428b11ce5ded018f357b6b3514e9d4b855bbd0f44c248dc2dfdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "936abeb7fb3a154e0fda0bc5a01508d5feb3519f8959b5e28857db00c7eaa910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f29bcd31bee723e80b51cfc703d127c9ae30cc9b4c07893762b3aea804a33161"
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