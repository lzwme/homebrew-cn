class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "307d8d9a9c345de31f973a4ab9dcf2790c32dc674bd0d601e8aa1a104fa8f3cd"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f246767e349cca723baec45a12360b3d64ff16f40ef027c29c58ac3a8676e61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c8685bded5f9ce220278e0389a6fc5338585da8bc468b021ecae84c67ee7a4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c5aa506fa2d0fb8864f6342cb95fe30ffbef8ddb5e0bf24512d2e787eb23fb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3a23ee0dfc68e8f23db9117963badd1f0f6335cf5599817b964d3d41ad2daa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23a907f62362690b5635040a7f6981f5529dfe571ac8e92a8853544784b92078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b48b4cca54d1999ca2a0498d5525f6aa82c61656556d055d2f46126b4e43b153"
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