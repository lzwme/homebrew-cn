class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.152.0.tar.gz"
  sha256 "d91b4edd1e666eacf048c2394df542a51d952aaf30eaecbfc48fff6175c33a6d"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "43f098d8907d9f9bd00773415daf2d407bbb3f7ee2d0d774885fd9d7e4ad1f47"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4cda0c23105bd47b0168661db3668b21cc5f28f69d02f0f8faf2fcc547104c6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "afcd055dee1beb4bf7c779dcbe52ec373043e7598071c61bf52dac0d8f3e92c0"
    sha256 cellar: :any,                 arm64_linux:       "c6a408fdebba6284e017c3d6c8ca430f8d37c14e203efe89efb807973a47f180"
    sha256 cellar: :any,                 x86_64_linux:      "c552b47d22a85521e7a70e9fe8abbf48cc14f9b45e867aa74c8699d650a63793"
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