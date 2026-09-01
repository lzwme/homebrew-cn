class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.129.0.tar.gz"
  sha256 "603d6a40dc7e077a3bea4ac4e75b71cc865c678c277b97df852e5d7d47d75159"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "558e6b06d6f1fc79a26a1c8ed1a7ba77d454c5aa4bf8e929ea3755a7c919f5a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b29ee1a60d4aa5918ae2984ec30dd6fbde42086d75b65fbee52b98431847ef07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d00932f2ae76543a6ddccf8f5d3cc9d0b0a5dc2e2793a62311ba57c92497b1a"
    sha256 cellar: :any,                 arm64_linux:   "3760d7b8710312618053f56ec5c9a0922a5fc4af5badf13f889dee94e7325aa4"
    sha256 cellar: :any,                 x86_64_linux:  "2797711e80fa9f2c57e20546d2bf73231d4e3440b163a7a4877a2fa26b414e01"
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