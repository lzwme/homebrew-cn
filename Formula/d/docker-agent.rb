class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.143.0.tar.gz"
  sha256 "1fb01974e494a663de6b9ef5dde665beb394c025f33cd9e8448083d245d03c81"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2dd298d0bf1a308b38aceadeef7b3ed4ce9544595a64a2341bdbdb335b6d68ac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "88943cc6150758ebcc3ee49ef92eb9efb7b6f5c760e5178cbff9691351548496"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6b72aa34fb41510ce97016a9706b3f476b2bdf208ece4cd9b6c9f2874c142716"
    sha256 cellar: :any,                 arm64_linux:       "ec113b2664d5aa9f0c628cfa0506d8a02e7580bc769ba6a1f6a160436fea665e"
    sha256 cellar: :any,                 x86_64_linux:      "319b2a88090cf9728d45df4787fda11931b0ad6f320a13dd106cc02f5f29dbc9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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