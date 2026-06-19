class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.82.0.tar.gz"
  sha256 "fcedcd9ed8d4c290baa972ae54a1a6c000b1191795959b36ff609c336daa275d"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d95c381edd0cd0ffa2416effc1d5d12d0f494b07aef2638c1ed818e31c92994"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9220df73858fb36aa29abe7682be1c2268185ea24b31669afd9d5cde96fe7ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a63e9ce00604a9d3837f9a2480c9ab86ab8796742fd8b9cf720a191458d7a53c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e1ca542ab3619796b014b9ed435a5ac94aa9ba1e0d3752466a24eb47c6afd02"
    sha256 cellar: :any,                 arm64_linux:   "4615842274cd7d5c7a170b817737f2da4c59bb198655b01fa71374b8c161ae23"
    sha256 cellar: :any,                 x86_64_linux:  "211b09dbfb4316037e738725ea8757d9232fa0fa5154df81f9d24fe6991969d6"
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