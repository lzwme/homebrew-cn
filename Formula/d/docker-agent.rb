class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.97.0.tar.gz"
  sha256 "d907663ed45006fd2a0405f39647eccb900f8d0a90ecb9d3ddfa6e540259edf4"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3c6c3718e6475f689c2660cdf53c3113e4c788e08c8adcd776ab765cb2c8c9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4c6b39204ea5c7932dd1c607d23a91224e527f683af6440c78b690b3939e1ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bff618ce850c422f400032ef165b2c6f11903d785c4e2d26864fa8b466fa0452"
    sha256 cellar: :any_skip_relocation, sonoma:        "e94ec97ac79805227648aeb616b45bbf6b2f892751fbb71d11542967606667e1"
    sha256 cellar: :any,                 arm64_linux:   "efa2bd21eb89ee6dc8f2c9cf76c7c9de0f5760cae49699a8f721d91c69f70c12"
    sha256 cellar: :any,                 x86_64_linux:  "5450050b505015766c42f9c272a6f9f46ff0c71a909a39760a911aa35f5e75e5"
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