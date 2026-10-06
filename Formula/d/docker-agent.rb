class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.148.0.tar.gz"
  sha256 "7d399499945164143c63b127836d32ae5690939c430e17b860d63fecd07788f9"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "46d19419c59349e8707a9c9f212cd878a502da35506aa92bb472b990f064c8d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9fd52a931be02b3a94bf8591d334b138771f302baa71659fc3c52b675c549300"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f22db941c41e23c91a17d37146ba20fdf0d4defa66471d3d8f1271dda620ed2d"
    sha256 cellar: :any,                 arm64_linux:       "44dedd929b047e3fba31d54f3c4edaf50982285b5984b1e125f76ab6e5c07c2c"
    sha256 cellar: :any,                 x86_64_linux:      "12caffc8b4268f899ac9e254ea12cc79f7742e9c8db2a62b95ef9949734f3b11"
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