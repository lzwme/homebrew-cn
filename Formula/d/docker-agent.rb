class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.140.0.tar.gz"
  sha256 "c07de941b7748f22cd148e15d84d1e21fcefc2eed84a10f744525ba6ae89b375"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6aa89ab0bca37e000d9b71d5affa412b05f7d9d6e2f4a469e078fc596a82ca91"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2f0291ac0ff139f0c31e3a148b69720372b3f657c97f15c466d47b17adc18626"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3380838d03a560f475712fc591ab6e2c0e697063c68c53630df44bb762e9507f"
    sha256 cellar: :any,                 arm64_linux:       "9a7d33e819d491079e2b78d3784f32e179e94ba25d9a33e845c34d2f27a37e09"
    sha256 cellar: :any,                 x86_64_linux:      "2979624db7c9c3289583a883a353b8875bdbbbb2798f53afb0d589c7ede123ba"
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