class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.114.0.tar.gz"
  sha256 "bd7600114e8f608fabd7b5ebccc669b7e77b975634c523b0b976627ca9cc839f"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aad2e82c2762740a806ec8227bcba048fbf5c0458432796a3fccba26a73beb63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d9360756c5965c86d7c725d6d993fffbef11b0c747232a0b978eef7f9a1468f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3ec3d46d2947649ef1cbb097be0859d1dcf26b382aa4c27420c4a09966430fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1eac77b1e3fc832c96e4b2c842e193931f5a723dd7b06d59b9ced8c400101616"
    sha256 cellar: :any,                 arm64_linux:   "0e2822305bc10cc9f01c11a70ae3324e8b6f6adb17d4f85171e1b45ad4e522fb"
    sha256 cellar: :any,                 x86_64_linux:  "18ff17e6cfa99ea052d44d8b3878ae7a0ea39e10dc55bbc177fe4fb2689700bb"
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