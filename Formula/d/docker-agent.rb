class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.150.0.tar.gz"
  sha256 "6565fcdf4f40dd125a1d13489e75cad7da4e6d46d0fc70ae55f7ad5d52c6225a"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "575c1353f98158802dd7c441ca393ec9ce0a104f27581731ec71fa2cb4c55ea7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "430b18b870928081c7d521f10b3f3b856e8709d9017a51008270156e2c73ac0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9f34b62b528d8149038bd0f6d08eb3e0b9e6f8a6e21ca25be32e9be27cbc14d3"
    sha256 cellar: :any,                 arm64_linux:       "aeefbaca5fbcda248cc8507cc67e571137635926f71c5c9a1ec12fc35d2e1a25"
    sha256 cellar: :any,                 x86_64_linux:      "3519e6292d7f4984dd88f25e8dae19c8720df51427970fd97fd0eb2ef834a32f"
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