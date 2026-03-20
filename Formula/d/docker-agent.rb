class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "9ea72f6f5fb41c694a5473bc43792de46428c9ed4d6e98ec0253110ae430f9a4"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e270ae952ae784197ef53c96866c4d291ee838a37403422e5cebe7366351b91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65a268f3cc404e838f0720009ff5151bb1a4b880271140ea37dc1767de4ca68b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dab060b5595b7c8382aa7ca7b4e14918a0b5b3448b24e676324f223b9309736e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6244b4859ea36407a0d025a0b7d238feeb5dcda34c251d8adff97ca55522cb4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d7b6e5f4f079c78a6dcd46eb4d48c0f42069ecc5bee70a3b21995ad81dd7b20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbc71e44428d9993411dcf806e01068f827d7a64f21cb14ed6df0e82a8ef317f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/docker/docker-agent/pkg/version.Version=v#{version}
      -X github.com/docker/docker-agent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"docker-agent", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("docker-agent version v#{version}", shell_output("#{bin}/docker-agent version"))
    output = shell_output("#{bin}/docker-agent run --exec --dry-run agent.yaml hello 2>&1", 1)
    assert_match(/must be set.*OPENAI_API_KEY/m, output)
  end
end