class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.61.0.tar.gz"
  sha256 "acdfdbd6bdc1267353a694bd7b56c5e85c349c3dbe45b03f7a812eee01449fbd"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "226148b5fc84180de72c3d69117c85ff1c345d5961bbb02f1254b11384c2b118"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "565d645826997b8e488099b0e48eaa257ec9ac2eae8db54562907bc0f4d21ff0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbe2b8728a87f03e5faa0f6c3ecd5d4f5e01cba1af88848e1290e65c0cae9223"
    sha256 cellar: :any_skip_relocation, sonoma:        "5826b292835d635c91a2a659724b6adfea8c2115f856bed062da438e9c9ada3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "761e2b71bf07ba9205eb7990f9f433bc943cbb2391ecb444aca6d1d191a3b7a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa95a63bb66ff86c536a2278dd9b2ac021df0b99e7b056b6cced8691679eeded"
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