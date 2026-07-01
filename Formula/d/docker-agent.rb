class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.93.0.tar.gz"
  sha256 "ac302a220c80757e4dbc830495c95b09b6fb72924764e44a4e09db6f58ff599e"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da133024f3f6fe1b92fe6dc088202fc2ae95303ea0bf73842e4913f35b57cba6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cc7d7651ab1f742aa813c480369edb55a93c5357161923e937091df807c4512"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fc24afe748033fc01e440d0c28c178b752f2e4aadc58117aa25a686839f0b72"
    sha256 cellar: :any_skip_relocation, sonoma:        "56cfff10f4a3cd8b7cb682930db3b91807d11c6b743c82713200b19d9a39cf29"
    sha256 cellar: :any,                 arm64_linux:   "6bdff76584ed144655fcb479f429473c689b2648300a77707994d75c4f091c07"
    sha256 cellar: :any,                 x86_64_linux:  "deed95775dd594973236fc096c61892e65bd7c178737a5de6e3ae0c24fdbf6c9"
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