class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "2ede2518180892ef140866495e0854076ca221cbafcdff35f212337430b2699d"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52fca3be3a65ab1efb187984f5f4a29aeac36611ff01a210d80b91906afb8913"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07d94e288e94c3324e5d22120601b6b61b66cd02ffed63dac66fdb227a5320a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b11ddd398a9b71d9cb1025b8c9b5e8de6b0180e51bf698bc9375e1deca99e9d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2006f72096122a2567577ce24ac4587608e215072f0da490b79d824e38cb0ca6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a031d943b84016e3a38af09096b30f8f4122c0ee583127182cbfb7b6ff823d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6da9c193f28578cef37c765c65f727ba5d64df227e3d22ab39bfc27ed41246a2"
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