class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.85.0.tar.gz"
  sha256 "f26569fdfae6fe0b61554994b283aacb9a94afc9f4df4757254e10c1a27140a7"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2b1ae54af787dbbcc453bf3faad822c124c0c3c631dab47a19f0da5ca6fc11e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f35be2fbb1ad539d81c0723410ee50c1e71a1f5387c500bd44f8da30ab04fcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fc5ae26d04135cf2599914542f0718d9255555e16f6f37c4375cd87a83d6a4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6413da9301f47db686a66caa0c1ff6e410d861dbbce4718a105aa80768e2b68a"
    sha256 cellar: :any,                 arm64_linux:   "c20c630e34a208b8b3ad6935b635a8dbc6fb17d82e9637f80da00a2344f99bd7"
    sha256 cellar: :any,                 x86_64_linux:  "7fc2d7ef2a1d4b3bbd5dfc748747d4c4807525f69707159f4477252fd1a5b824"
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