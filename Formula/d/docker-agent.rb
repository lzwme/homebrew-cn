class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.44.0.tar.gz"
  sha256 "3a99235130a3a0ec477c17886a4bbe58a28502f15f48af210510a69c3f1df419"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b59d171bcf490a2a3ec9da75cf1abb19fcdc08fee884de7c77ff0f82da6488d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d75d5baac94750d8b5e601b38b65ee77fe66619a381475414e601e0a76685c45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5446355657d7ad01d32fe1862bb3618e5ac831e877207d22fb4aff38eee3e88e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f97c0abea88997f4ccff3a24fc940be0c4059c795466e36b5e8dd6a08c454a79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5b80182e97c98b910bda5e0505a9ab282a6c0b1887ee13aeeaa22c0c7a627cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33d0422b4fdf399230da9f529dfa8e01a674555ae68ea1a90c94dfefc361ed15"
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