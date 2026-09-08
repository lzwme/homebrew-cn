class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.134.0.tar.gz"
  sha256 "29ffecee6ad7a297b5ae2e256ebe9d7f0ea96043534d654f2ab2e0c312da4e58"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd773cc1917731d8e58bfdd9f242811f727e7015d8ce3206df40198ebe9e9857"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "388d3e40964d89507a9ee447b11e9f01709c8e0bb6ea045b0b61c506c459c59e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7cb818a962a485f4035198c74c29da2552538a294df52a9719ffdce1f446516"
    sha256 cellar: :any,                 arm64_linux:   "a643748cd9576d14f9ef0311c2f7b927826cfdf9719d18a2cfd23f51e37f0224"
    sha256 cellar: :any,                 x86_64_linux:  "1a5e3b1fa620064fba52044b57eb7f5ec10cabe960df67b340a82ee625e04b8d"
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