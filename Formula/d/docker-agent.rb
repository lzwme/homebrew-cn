class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.68.0.tar.gz"
  sha256 "ede676cc246924cd1435357484171d7df1aa4b2fb3c08cb56cf0d6bb1c94de1c"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "373758fc4795075d833ca2c2a936120059234213cea4a60f58008f15ccf34b83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3b3fbb6539217c7a9e4fe1fafe9d16f17fba8017579a1c14e7bbc380241447d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33ad948f2530a721d753077c45fe6c1b707766fbea9d10ad7cbfe78d9493fd97"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca642f70aa346c1a8686afe512fa1d339d1aa2a863c1129e28c2d89bdae6ea4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7ab86f8edee1743088ffc763ef8fff64354895ae0c3e0f7651166ef15db55f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf7c755f02a848586cc97a21a28857603b3ebc7538ddb6cc9019285fc72623ff"
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