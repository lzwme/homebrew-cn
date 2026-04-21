class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.48.0.tar.gz"
  sha256 "8dfee26de6ced3610d742597426d927ef33930599436a190bc633cd098f1efb2"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2b357a11a1687b0daad0f3c3e02f496484abad5cb1d4058d7c0ae87c422242a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1db40b4bd2cfa61785a746dc8578d9751d182539a62d15c9ed6066a9962edc92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edea124b6af5de97807ba0c98135abc441afcc3ef0118ee3eb05f3bfae0c5426"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b44f78b5553a985d10f136931235e750bd0127e20e5b4e9c472c09fca6c9a57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f50ed366888d689771780d019e4d0ecd3f276a5c5a638ab8dc04c02ad8ded0e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e86f477930a5d701a3ca22d539fe120e52867fdd88dc4c0203c930e6f5dabdd4"
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