class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/obot-platform/nanobot/archive/refs/tags/v0.0.85.tar.gz"
  sha256 "97b55211112f129284dadb63ed0878e93c731457b4b1da6a851fd51c32149b28"
  license "Apache-2.0"
  head "https://github.com/obot-platform/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1461c09be4ec61db3e15dc98d93df216f6a6ad339729268ac8e105dbf858b74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3654cec0c512aff3f743a2b656b13eec2421739e4bb7151cef60f8ee2045628b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91abb6da39136c7d4996e0c7d406296edc4802f862f7e8bce823962ab1032a0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "46c902089aa7e2a072ed96c18af436601cd0183565910fa196ecf6729e5869ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98aebb7e6cb9b01376711f1585b6a7e65802b9256b45d498d47412ac827546f6"
    sha256 cellar: :any,                 x86_64_linux:  "f546f776400d26c22614ad0a0c51c005e8756680a02579bad981bebeec8d0996"
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