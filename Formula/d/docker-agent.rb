class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.136.0.tar.gz"
  sha256 "685ab4cd5c7220e730cb1e48df315af2d03231a69b77da43a18d592d4ffd9f46"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7a4719643081f9c2da220ddacf8d6c3170e9429a3309f23ed10a6c6e713f8ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f48de5127278b9954a7918a37ada6ca9f7da557241d0912b36372258385f42e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91c6e5179fd68c3c1ccc5140a8541cb7b57929be7dd53606cbaa21faf97b25f8"
    sha256 cellar: :any,                 arm64_linux:   "246ad7dabd8023f7d828336ea47fde9e70cd4065b07503356eb7bf924f76d572"
    sha256 cellar: :any,                 x86_64_linux:  "0f5bc2dd20ad887f39076b6971f7ae8c26a399c65da9da2c9b11ae01a72b13d0"
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