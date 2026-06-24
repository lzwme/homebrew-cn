class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.86.0.tar.gz"
  sha256 "dfb4903899c891af2ace841208f8978373337ea45e25a0a95bc709dee1153f38"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a96ee9281ef64682dde9f037e207490040d6be463abc2bfcd200f012ee7568d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5727ef0b0fc54e22ce9b8acc37570dd019e5ea65c7bc15482fafee8218ea449"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67b2df0cc5e6f3eaae05050b9c2dc1ddca506dbea8d1ed39bc80193c68cc26eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb5e1ab5cf5307356018e61439baf6044d5b8d17b8cd6e75dbe6d9bb83a2ad9c"
    sha256 cellar: :any,                 arm64_linux:   "a4f41db5a1c27174058022d90c230872b2c3a182baf223e0e9ee765651d8888f"
    sha256 cellar: :any,                 x86_64_linux:  "bd63b8080d0ba8353d6fe83b8c4d0ee8df1021f140e3d92160dab0abf1f2a999"
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