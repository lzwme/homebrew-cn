class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "f165b7667edd9ab3c9e5aae5c327ba19b6fdf6aed5b90b477782d9a2eb163ebf"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "533c1bc07530dc602025f6d5b7aa621505c374b162fb10f957ab1c5e45ba8bff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6848c1695519739fa300c809c81ee74d840fdec055d3c3c6045773de060ef314"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff97861c93518bed1e9930315347b087ecb3c8d79defaad6f10c069491ebefc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "877041d1445ad83a312d1cf636789f87c7b94e3bc10d9d5f37972e9a930e9bac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "843ecab97c33d5e91dd9ef7ee1d51302a61bab44e158b943acb2bf0ae6f27d2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6600213581bafa7bbd74c84578edf64efd076ee5d22012cc48d70e24d0e18a76"
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