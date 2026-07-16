class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.110.0.tar.gz"
  sha256 "e2062b23ee3b8775de7ebdba89da88835fc256b1f938932c2c103128a53642aa"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99a1f8d067a0843c3d6291a9e663e67afe31b00facbbe1ee3cbfc1a9587b73e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96e2b5ce435a0669716de819929b90284fe0544d3c796101947df85f09ef2bf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c586dc6600980fbcaac197b1702b69aa11b35b3b99be4ba5a74a01303ac1bd22"
    sha256 cellar: :any_skip_relocation, sonoma:        "f21c824bcc94f15d774ec0f1648a1dc5e2b34e105b31c19af0e224b5e864fdd1"
    sha256 cellar: :any,                 arm64_linux:   "97fb294458a5dfab3fce4979870d4dfdce059a2db9a12003ffdca3e2cdc2b5d5"
    sha256 cellar: :any,                 x86_64_linux:  "8c62d8ea8dc14d4a53f18412ee373ed64c2bc9da5d6e9d2e36159829b5fbe947"
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