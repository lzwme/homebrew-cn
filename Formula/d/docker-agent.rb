class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.69.0.tar.gz"
  sha256 "10f072a73f2d79030c6c4c193d3e5380887af6c72beed20c9f490d605965d1b8"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6642094bcf16334b929dea744a3a171a3ae3b167e92f24b5abf9a2871b3363d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72423ea645e754c665c3a7cce23ab59a308a5f5ac7477b8e78344088325b6da4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ab2801516767189bb3333e87a09a9cddf53053072e5df38353c33bdb45ed410"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7a731a77886bed9933d956675eee82853c1772122267f281fb2b9f1ae139e9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f0dc4c51fb2669dd4e7996fc822ac63d634ff2ff9092d6ecae832cd6ac204b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2531c882414f6cf9f3f1ddc75e20587c038111709bff177052eadde2ce07b980"
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