class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.128.0.tar.gz"
  sha256 "a0b6170bc47ca934a9b5fcfcae594c05e767f5daed7893d18fa627ebcc290cf4"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10375d655c38d373870cb564813168d2529edcd782852bad6ccfaa5150be44c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f69accc075c45dbc5141a0ab965e6d11d1024e2d71d5461f2f04c31d8bdea4f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "182f32dfc67f6dd2a4a6aeba55683eeb8858127af7e259511bcb9abf93632019"
    sha256 cellar: :any,                 arm64_linux:   "214912ed307432e47c3c0ed3b209d9a137aba3792b9b94f9f49d52b0b6dba94d"
    sha256 cellar: :any,                 x86_64_linux:  "8a6f72c902602c41e5c19c96b861bbbb70e103f26aeff1070c7c5e07f898c5d4"
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