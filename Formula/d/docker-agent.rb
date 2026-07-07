class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.99.0.tar.gz"
  sha256 "f45186480ee9accebafb47c1054ae13d83d3cb88411a17492ecd08e915dd40b4"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd540b0fc115e18b5730ba898047217a09e728efe6c7d822bc6f47b3af896a2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaf73df71440a11b6618ce16db64816aa00477ace2710ad0284e893d45aaa4f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba02e7d885916b4bf6e0bb83046a34b580a1638254c3e64a8500ccccbad133c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "90d1a84214c4247eb8bcbf362ea854f07a84e1e0c2dae322091e87467a3dd108"
    sha256 cellar: :any,                 arm64_linux:   "84fdd9c20ad074f4201d09a8d07a949fe7e7287fe77905f198bc24189585e66e"
    sha256 cellar: :any,                 x86_64_linux:  "0ffe886a7c219f89537867e1edc9e774e0a175d98bf931aded77d56db7b462d3"
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