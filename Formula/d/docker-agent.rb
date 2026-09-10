class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.137.0.tar.gz"
  sha256 "f7d697fa7950640d2efa533c508087f3073cd0cdb5b3a30cf7054d68cde97d77"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0927821013dbf07fa3c30f1e668c9cf4f938a7f526eeef1baaf17dad6a19c528"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38f21d7c502ee32a196e0f12812be61be665253b984e7039c9e0787c216d73d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64c33793a58ce1aef1085de845e9ec7d82e2ab992e083a66d7dd4d9294f6c3e4"
    sha256 cellar: :any,                 arm64_linux:   "444f8bdec0f71d1fb751959c3a1f28b5b910dfeb5512a6d09c6fd4720bc7f3b4"
    sha256 cellar: :any,                 x86_64_linux:  "b85d838e9b397d260371ed2330ad07e62c9f969b88d38041d2b9ec5bf74010d1"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
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