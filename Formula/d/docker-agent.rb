class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.101.0.tar.gz"
  sha256 "43fadfe3ee5301d09f3ec70ed5e9ab0e7e7be8c135d43d4020dfdd884aeae3e1"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b653d977ac6cb6d18d00eab1cade069951688af67b7ae8892d9eba95319aef8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b4d34e1acd5aae2542499fb6b2cbe74fcbd95b9893addd637b40f0058057f96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33eb196879014be90246691e054e144268e0d03f754b9c1f71508284c78baf54"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b62bc52ea126ad1f5aadc4026a1a00f9cb45fc9caa0b6bc2170a95a67b0b61d"
    sha256 cellar: :any,                 arm64_linux:   "c5bac17d23061c1aefd360715f1bebe42020fbc05ee9601b06e98636f58ec043"
    sha256 cellar: :any,                 x86_64_linux:  "fb813bb376a1cbc6760cd06008f7e2f3627b6757b6abbd18efc0a28d158b4798"
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