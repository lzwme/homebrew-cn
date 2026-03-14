class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.32.3.tar.gz"
  sha256 "b0e8c8283f65226200e150a20dafaf0c8e6d257339063dd258b28ed33e38138a"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4df7bc58237c7df9944619180f9ade919c964477c39a0dfb792cab5f0c1a4eed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e95633404d29ad87e0327744443f5bc390c73705521bff34dd7f27e48e271683"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "858d561e4d5ed808db80ae7babcea1deac19f9208d36432275654b4012cdb390"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a06a5ae0181f5402b511fbbf5d743e2b57b63b7d382903034710d32823e71ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61f35a18eb772c41de8d4e33bf111ea88a10a043d620d3d411a095241f044a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74b695db3f87e75ffa0d6a1229bfa7b727fccab33968030d4bd12efa6e9863a3"
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