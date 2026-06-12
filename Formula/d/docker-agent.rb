class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.78.0.tar.gz"
  sha256 "7a37c84b75ac6fe39d7b45a404aa52e2293af484f8e31f95c8fb47d4203e8792"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abff27cc9da65dfe17b40518d39bda6c9b9c20b3a4e2ba9b7e672f1ca37358c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28d64d0b6d47b852fb1e8cddee3ac77acbc6245ac6a9211f8b21886228a7e2c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e39d73a90c4a847c7044199e8ed1a160600cc40b34cba0aabda4e0676d8be2e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "447d63462945fd9741901d6df59674ec8918f79e4ef6c9517641112d71eca221"
    sha256 cellar: :any,                 arm64_linux:   "cc0080c4111698b562193d709630bcbd51c61e8a2c9158289d921805ea6a6d70"
    sha256 cellar: :any,                 x86_64_linux:  "48c327a2e273d8b37dac8d0077962056466cce5b0f5fefa4931a63205f4d800d"
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