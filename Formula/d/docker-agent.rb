class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.79.0.tar.gz"
  sha256 "b3d23b1960d21cdf949f52e851b243c41da92741100c9251f491a2a6e17d4b46"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b27c8c535e5c0af95cfeb754926d28f92b224cc7a8dc8fc55fa330afba266b32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "697fb46ecb33ea54c3b8626147d70592444b0d2a3ee44824cbce9d4995c8e00b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b30118badd76e1280bee9839f71384422ce430dca4b7173fb72fecbed69d97db"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ba9c1f3a03b462ec2992aa5769af57ab94c0c89bfc8184240e0f0103949b488"
    sha256 cellar: :any,                 arm64_linux:   "28870b6dafec6a7b9e9cbe446d8d3939bbbd1ace2f0160e61a3114a7e43b20c7"
    sha256 cellar: :any,                 x86_64_linux:  "124547ade1314caa6b03c38d7013169bea058ff0f20e0b0e3c880bb1bcd68078"
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