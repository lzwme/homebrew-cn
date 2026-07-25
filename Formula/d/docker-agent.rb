class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.116.0.tar.gz"
  sha256 "f15f7524f0fefda6efddef39ee27c10e58084663636b9ebaa2a37c6c04d9ce30"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f7927b8eb95e05c948d70b96258782731ed5492f091605469e797bd36b804ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a3f7d4239a6547c662c9d9d0236079f725add6cc0a45b25b54f45ab2da1d300"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff43183633d2b8e1b4b629b7b9845ca95d05e10bdf5450d94f99f5e14540e8e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "38d7c03dee89fb649a462db767d87f4bca261a7f3b75f8f0a2c9b162872a027f"
    sha256 cellar: :any,                 arm64_linux:   "3591047a9f4d7ea25a2da4586abe5ba834ab00b9d4e5a2e41161319b216a74ba"
    sha256 cellar: :any,                 x86_64_linux:  "34dd02077a769d9a83018bfb3af2f039e784e6eb4224f270db1cb4ccfc585eea"
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