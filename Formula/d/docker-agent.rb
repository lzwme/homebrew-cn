class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.138.0.tar.gz"
  sha256 "6c707dbe2fd47cf08f855523d136b5e9e9a3978128bae6cd59231957d7ced8a9"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9b2e62b70a014e63aa0150cbb0a624326e0a218aae909e126562e242261ad52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb63da7e79ae6b7046126e0e603f1da75de1ced5f74eac2d48ab259bb6d80968"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b08ce455a2faf8dc6f76b32af153cdb1741bae1ba18b893f9495001928a90f2c"
    sha256 cellar: :any,                 arm64_linux:   "971fbd9c34c10d8db879b913fc1a5b0ca6f4d6e2de67febee6de264bae0e13af"
    sha256 cellar: :any,                 x86_64_linux:  "930147ad961108d47aa2704d7c4fcc6558fcc5c8ae45c78830b3c74712219bcf"
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