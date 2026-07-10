class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.103.0.tar.gz"
  sha256 "fdd6d2b29750380975bf07e9c058a06a60913af156fd8f4938a40beb47abcfe7"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "777e6ce4b8eab626b46ae4da1137ae866e9783f8b6d2a916073c53ee9911f99c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53aff7bc55633102b673044e32c97aa7e4a400d395cc2d19ba7b676b7df0e563"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b563fab6364352f5d17dec2da997ca58df049af062362b2ed161b1a793a1d60f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e33d7b9f3ed571a173e1e651e6123850f6e072b6d4d0d612bc6fe83fd24308b5"
    sha256 cellar: :any,                 arm64_linux:   "e54d194f38620b5f49ceb187fe585deace80f5ce60e51baa08c2f6f63ede1858"
    sha256 cellar: :any,                 x86_64_linux:  "5909389ecd1ef8f27952cfd8fcb5c1dd18ef708e8fc60f7741309b659f9e079a"
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