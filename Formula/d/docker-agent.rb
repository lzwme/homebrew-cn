class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.98.0.tar.gz"
  sha256 "5f6ef04ba1954f00b6efea11b7312e9443c37936b4074d1c9c1f7c0ae92251d7"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1826e5e0fe4ffeab9e6309763795bb4533efb8ac630cbed6bff21ddd73e9797d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e229fa903b04dfa9678d630d13eff3c948705fe9fb17bd8978065ca1de70e4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c05ed42c2729002b5116838537cb493c968fc5e59e8a2bec8f78cb3d8aa4257"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c170980aac40e62cb609ca54c09a1c95a47caae6af2588a570633f5b74aa867"
    sha256 cellar: :any,                 arm64_linux:   "013a3a62bb73b0abfc85b965e34cc3e8a96772512b201c634f2488d8818d68f7"
    sha256 cellar: :any,                 x86_64_linux:  "913f116bf1d022b51e8df2b3cf614b5a24d45c78d86727543d800939e54f12f1"
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