class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.146.0.tar.gz"
  sha256 "f6a992108c288019aee9f3756cae89e2e7ce0f21d5a71f281db212616188f25a"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e4fab2461487eca4865c512e38326896486c48e5f01794859872f6237cbb6014"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a243f44dbf9cb3d67d093782b43b601369dd12c5fe3085a76391143b40ca3739"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b70cbfd6150981da9dcc5b024d3cc615b38cb9739f7a9de9088f31e7a6930d0d"
    sha256 cellar: :any,                 arm64_linux:       "4ef70f0b32cde0b88e6dd53c04d038085e6b0c3c81cb83dc4ee21e1b49e6a1c5"
    sha256 cellar: :any,                 x86_64_linux:      "005aa6df4c456b129eceb0fd7e5bc8cdfe2b95fb18a73808330fac912c3a7150"
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