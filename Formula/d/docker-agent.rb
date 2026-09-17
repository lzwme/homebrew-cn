class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.141.0.tar.gz"
  sha256 "0a6649eadf1a9b4ece2254e9e133f1393fff7dc6656316cfbe08f8ad76ca18c0"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "14b66db8a0e627ce0062f343510ee50e0115066606b0352aabe9831d56cdc136"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e0b4fe22c2e6f3fec3b74133c36af2bf729c2d614d863017fc1fdd56acbe058"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1f106a87dbca0cbe2c061dfc003c46d9453c691b90362edc80c8331addb1ebc5"
    sha256 cellar: :any,                 arm64_linux:       "d2e264e056e3e2c64b3e95e1aa9df907993fab2fd467a7501b3a0c967adf77c7"
    sha256 cellar: :any,                 x86_64_linux:      "45343d38d506327107ad39073aa0d05ad3aa24dbf83b03d67cb565ccad7e7633"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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