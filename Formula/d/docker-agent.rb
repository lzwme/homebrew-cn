class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.83.0.tar.gz"
  sha256 "a9507a791f439c672a4320b2ca13221221663924e9899cbf683d13ed6db2d7dd"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e4633c731460534392aee37fe3825b387e704db8f3ee8654a3d199c0dbb08d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a45b6d72c06d524f13e322f37bb478c7d04ab2fedc6a2377e05f49df7454ec1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db27fc2c25442d4ed2670a6714966b8548660e999e61b5aa7c08dece1c3e8492"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2a114eb4809a91219950f90e1ca467fefbbb57df51a6cfd68d37a1e0c044d45"
    sha256 cellar: :any,                 arm64_linux:   "3f7a612acf405eac8ac8c7b448666ce5b82c3e61bbbccd53770b50abc743208f"
    sha256 cellar: :any,                 x86_64_linux:  "4f8942a240c04ea07b788ad0e836f997cc7c091ad471af2f632b3f06fd780ccd"
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