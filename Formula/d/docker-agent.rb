class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.72.0.tar.gz"
  sha256 "2420479067264cfe0bf9446f04f1d052cd6ad55685fe99ed9ea4f63046758c10"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1a76dcc6bfc8bfff0f51bfdbbb29f47d896f1974e7108b63eb9acb72a911903"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c75c5006fbd780f8ebaa789afa12b167fe401f1421a4d26d8e24a1dfff710b4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f400560ed18e186b3d203b5de6880680a67c1e44fe5a21f186d55e7f2082c8ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "438349d8fa1f9bdf98f4f44776ff355265e034259a1fd2df4d6e7c3fb8151580"
    sha256 cellar: :any,                 arm64_linux:   "a6e7152fd7bf44f01fbfed8d7b58824084f1c00b5e091191cda94eb0aee8bbaa"
    sha256 cellar: :any,                 x86_64_linux:  "842c72ad374a711ef8af34097f17231d4c768d2c53ef2882717473252b4fcdb3"
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