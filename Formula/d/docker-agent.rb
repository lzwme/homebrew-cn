class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.130.0.tar.gz"
  sha256 "1a33d773607fdc34f9e939df2f129609fd88471d2f940cc4e8ab2ff5fa04f5be"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50f61cc8361d0c595a7dfff4ad76290729e94e6c2f04b422561b11ba95cb29dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "379318cbe2e6429a37c89b2636385da09638512ec0dfc811762b1ccf996104ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85283ef868fe0c0996fa66349d98e419b5a5a1692f0b5a8264d8a2cf4ddbe036"
    sha256 cellar: :any,                 arm64_linux:   "7ab5e442cce9476da29a5e28e8c9daeefa103a2964b7c94c7310c35ee2682c76"
    sha256 cellar: :any,                 x86_64_linux:  "f69bdbf493d00abd75e336433ae483695bb963bff71af76790352824a3b795d4"
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