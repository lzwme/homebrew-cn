class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.119.0.tar.gz"
  sha256 "f16b72896646e63e93749018dcf15440b757a036247949a13dd84f2ed9f69935"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "527451faa77c00989e8b841763d84104795095ee8f91a93ae342f30604917f48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffba1a1a877e0d903bdff813f3a9f8093b67b7e5330d6100373e3f60294e31b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccf93306e3114b0567cfbc799e3aa77f72d54e4fab15fca9b8b7ed48ee61371c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e389a9474ea8a7dbb38c727bbafba73c4092dd42cce0d818c445a9df267088be"
    sha256 cellar: :any,                 arm64_linux:   "e5c601f24fa43d21b5d3b726f76806987bccdeb7e18b2dc9a12d86a3d1c3e72a"
    sha256 cellar: :any,                 x86_64_linux:  "ef6c68c26209ec870cd9813386fef8baa6b4f2f28404b8b8de203218f891feb5"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
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