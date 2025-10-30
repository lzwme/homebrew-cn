class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "a7cbb7d9323c2c017f9e69525c7237159f17cfb2322871fc2b38caad1a0d11e5"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3538117dc84196ce4b03310f21e768ff7cadb2c52006c07df0454413c6bdf37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3538117dc84196ce4b03310f21e768ff7cadb2c52006c07df0454413c6bdf37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3538117dc84196ce4b03310f21e768ff7cadb2c52006c07df0454413c6bdf37"
    sha256 cellar: :any_skip_relocation, sonoma:        "def54264a7d87b5bc080c207b208ac3efaf122250d6100942694e03a1a3452ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff0d10ae1b1090b829681eb6571e98f2943b732caff58d1effd01d0d187d572a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0c72c09e52bd95ec06b9c87b0082b0262dee2b56d5d2a549ae0bdbe505245f9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/cagent/pkg/version.Version=v#{version}
      -X github.com/docker/cagent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cagent", "completion")
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("cagent version v#{version}", shell_output("#{bin}/cagent version"))
    assert_match(/must be set.*OPENAI_API_KEY/m, shell_output("#{bin}/cagent exec --dry-run agent.yaml 2>&1", 1))
  end
end