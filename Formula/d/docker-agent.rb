class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.149.0.tar.gz"
  sha256 "7f0325d50bdf5cc75f0acd33b69798b4b119458333eeddaab7d13e149fd41bcc"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b121b903e7356bc03c94ec28e5b4391882c70128003c2129e28f80d71ebd6bee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "857cdc7374260ece1032f24261cbfa9e745d39fc7cd4e4b4ac750da814ef0f5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ab4445e854fd46ee62c99696707cd86ac5d853fcc06737e970cfa082a1f13ffe"
    sha256 cellar: :any,                 arm64_linux:       "3d5f1e9bb5855d5b8e01cff07b5e4aaa5199d38a98152a46e6456930571e053f"
    sha256 cellar: :any,                 x86_64_linux:      "63ed837afe18776dd01988de402caa3009e55a7c4839f96e5db3f515c32dfbba"
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