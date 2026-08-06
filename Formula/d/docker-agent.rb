class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.122.0.tar.gz"
  sha256 "87cfa6052e453dc3da79a4756aaa8856e94cfce7d08e736297a23df8d2c4aaa7"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9e795fb72219920b8bea649e912352e08e872c9501e874886a36ef683c30814"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6fecf08e0682da3e1ea2d309f09c1216d02ef120269b892d070be180eca6996"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2da1c81ddf31506b2177c3b688fbb8563bc40abc620005505a0fc8579f9e7e46"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4ab2111c44ef29041c6d7e7a20c60167bc886b77ad6fa284204ed2bc83c1d80"
    sha256 cellar: :any,                 arm64_linux:   "85db63698ada7657d50bde5a3bae746bafcedffa1714105720869cdeb4dd406b"
    sha256 cellar: :any,                 x86_64_linux:  "4bf33224a5dc9f8f24a2844d9a3ede25d6256cac7fefdb6e8a2920d364ad1d75"
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