class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.32.2.tar.gz"
  sha256 "fa99f4738d0fe2837f93aac64724bc743099355c6f82f0b6d765f798f290ea1a"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdd2727b47ff5d489755199f23f93f70e6821a99c8778db7025abb8c0049e8d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdfe39fef65a7f140ab060388d21657cb138df763cf77f1958adcaf681ffe9f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "002e9f1c0fc2634832441370e5d68b7f5e44d12ad261671962dd6c97f8a6248d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9db7d96bf9f687f13d1f4d14f6adc6df2d833959d7c4e7c889d4851a49969dbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "013b68223bd4a58a4325bab41ee04399a1d8b2dd723fdf10d283d56f76f39e14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad2c53eb73f711b3ad31a7f3d352429a888449f4d7cc0628baab4da934e7eab6"
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