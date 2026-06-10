class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.74.0.tar.gz"
  sha256 "ca16849f4052c16b07a9892b245e71c93b61eaa042636116e8b97f1179bbd73a"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d9a20d8b8ca8f1427593278a9cbcd5ab592a48e2d5dedf3dfd0551768047121"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df55babc5e048d885bf7b4b676e5f0a75ddbb8198972e05375163cdd4adfbdcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0fe33b77bf9e1ad40b5f34b51c2b1924d37899241aca8e384d364760a6d02dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "75624744525369e81406fd06f3c4b4632af398f018c61a87087be29a701b1e31"
    sha256 cellar: :any,                 arm64_linux:   "23eb11ad16555e03ea5d317703bf83447b8f4839140dbf98dc31a6982afe1298"
    sha256 cellar: :any,                 x86_64_linux:  "611a2b6803ba2befd95ee4f09214272b171066abd4622c5eb5e011c355099cb0"
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