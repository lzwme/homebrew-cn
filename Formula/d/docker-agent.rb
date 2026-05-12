class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.58.0.tar.gz"
  sha256 "06498eae3f994a0c572f4ae3ee49ff39ecb4728d12a5fc9f11329bb54dcacf88"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "420b36b687238ed83a9cab268c2839dd331b33cffe473a85aec37e49be9cecf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52d470a2f3374b33074e2e32f831d3269cf00d55d656251c0d271a8e77224eab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "316aaf89102c964a51bf0b9d035a67f6f2505290b5dabcdb4e54ccacd628a9f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2976bed7278ded33072e7fa5903130738f182907b480ab8e7789afdd48e6e78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c94471ce8db9740950d1aacc1ed4ff5845d146105a45015918bd87260b93c548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e72c3fc3ec5fd44da7674312acc56409dd125e06b9a9134e9cc7cc89e83f97e"
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