class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "34944a4ea86e8293f613ba68ffdca02ee377b2d5e3a3d9a9007a98268b7da601"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "972016ed88641dd985b4ae76ec4b2085b63955329369141e0435c2f61dade10d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60ed075973a5c16769a694e9ae8ddee7dd21bc491c439aa2b3c2e8bc44cc8a45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c14e913190c5db07e6b2da45f296a5668184329ff2fc9cb70a6ea319ad248295"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0ae4fcceb56809a863c4c6a4981915d5e63151ee3a8d87de119d05cb9d79205"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf7390f1e6a9df25bbe290456f66a9542fa56f02e06db490eece9749d740a6d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d06822d8ece596253b09d3a4cd4852f60437b4f62c403ee3a1ffa99d23e8b7a"
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