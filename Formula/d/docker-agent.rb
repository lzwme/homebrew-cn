class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.124.0.tar.gz"
  sha256 "dc2131cd9ac4cf51f0c92dd8ab604319134ae79986413ed754c455b28949a35f"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92464fe51954297f68673386a37756315f82c7621d47be989dbfabe7396e16e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23ce8a41259c3e498b9d0c16c0dfc4d1b2f44de20772041aae86d673adaa11a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18fd89a28c44b889ef881fd35267c483d7d89d6814e7a6bebc2798e05b0ce80f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1651d016995d5c0bedf233085c0d5f69ec5e25ae4d0463dc594ed50e2f291e10"
    sha256 cellar: :any,                 arm64_linux:   "5945bd3c97fcb0cadd24f74a253c59c002c5d2d0be8c077ae7f31960aa1ab678"
    sha256 cellar: :any,                 x86_64_linux:  "9493f87f9fa2d1a60aace7e78a93e82f4e0d96ce03162f229fee0173f903bfab"
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