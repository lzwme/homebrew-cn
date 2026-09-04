class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.131.0.tar.gz"
  sha256 "d8f3963f4fb220a2435a5609d85e09f232283eb909ee94a269ef54233659c100"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "017dac5ca71d20b091f97398690edb6ed3c433bde158f3e9c455581e131ebb5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e7cb33322649abcd95a54d9a76a90f148e74681f974b46c718725430d20482f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71b5b6ba892e9c28c15496496fdbf9ca1349112efe60a11f2995cb58d682317a"
    sha256 cellar: :any,                 arm64_linux:   "e75da0c57da68557d74959a2923924bea9d69299dcc12ee1f4b0fc4b536dc46a"
    sha256 cellar: :any,                 x86_64_linux:  "e4af360af03d968cedafc5359eb95a809202f95e958a302111d1e19c44ea4395"
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