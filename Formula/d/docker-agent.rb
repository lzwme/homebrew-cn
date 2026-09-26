class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.144.0.tar.gz"
  sha256 "729c9ddcfb407cd0406dc044e2f2536d7bbd12d9365e0d2c631ab68eb727ea5f"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4f504d7d89ec0964aba0c04e2276c73b4915e70f38bead5761ecf1a21127a323"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4cdd20a9b432e5aaba08db4d4aeab9fa28905aa54556c224c9a40a81641917e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b6066367df459da03743b6b64eff5b821a79d8be68e8355de5d1edf344e33656"
    sha256 cellar: :any,                 arm64_linux:       "e4aaa42c525db5c70b6fa42a4fa13e317d9018cf8d6f4df801b4822a2ba00fd1"
    sha256 cellar: :any,                 x86_64_linux:      "51ca98b83f50deaa196f6551469011e81862ab8656627fb04f5d610fffe1b288"
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