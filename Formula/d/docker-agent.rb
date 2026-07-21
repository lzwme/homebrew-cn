class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.113.0.tar.gz"
  sha256 "0e497f847d3ed9fdc18d11e6031da3337c814c2ae414e943c8b612fee3b6dfac"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d89300ba7b72173dc0d9891087e2dbc14ec0fec446ebe2a63ee06916a3f1daa2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c1bd34834adfd85d7fb072fa4c40f6a6d6a645f2f7ac90136e52516184eddfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2d992fbcdbb5629ac1e7946d225ff2973c11e5763f09ddf6e99676682d0f500"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c75ced39305cbb39fa3790ad0c03d7bcda0370693eadcf6c90cfd72d59961fd"
    sha256 cellar: :any,                 arm64_linux:   "ac8b3d0cb730b413680bbb91882e4a28849e0de166215e745d5aa3d1f0147499"
    sha256 cellar: :any,                 x86_64_linux:  "58bfce70cf5dd9dd0530fb3935ca2602c5862c8a6efb39e974af29b58460032a"
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