class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.70.2.tar.gz"
  sha256 "1ac619c6b37df7a11cfdb7730f348b9da923ca189405c518d84ad790a172c07a"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a78729a5b361f10697ba21b426cb50f8f3b02e331d9266feac9e693ee3e2f31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab95f4527838aa0f8ef5f5d332035efc6bc9e7d99cd4ebc9eb9608e55123d7f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fbf3ebbbc7eda8032b8b34d46de869052553ab3d13ecaef032abe39015557f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "83b2042a75527ea1a2bf084a26a1cf45409fbe9d7d3baea529f3d97d27f90755"
    sha256 cellar: :any,                 arm64_linux:   "698ac9a565ef4959f85ec9ae3a4d9653340d4b9af74f097e15628febcbed7e56"
    sha256 cellar: :any,                 x86_64_linux:  "ac5bac73f41af668bcb71fe9dd9f7a73f9f1bf92c9e64cd21fa39d51d62d3b31"
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