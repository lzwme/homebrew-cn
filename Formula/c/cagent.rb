class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "f245f45f6cd136b59d5d00f3a0509f9350ab6d5d312e88c4f163f04ed34f4cb1"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88edd36f17cbb0d457f531216e5cf85563f25775cbb6c49ec60db29de1957b37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86f702327555153214a05a9b2d072e835d5ce7080a2f112118a096e540cd3720"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cf81c6d3fd638f9b1ecfc1aed909fc12d9822b9f908d53b303aa7cdba1921e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2aa62fc7bb6315faed6dbf84fcc528497f1b53eac1fcd0fac25c0ef1927929c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f33ed11d9bc44fda4161c53a2d95d3e6584db2a27d3c2cecd605a4a203c1fedc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41c291856caa43ba1cd0ec636691ce523c93e9f80a7fbac0273af03046a5e4f1"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/docker/cagent/pkg/version.Version=v#{version}
      -X github.com/docker/cagent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cagent", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("cagent version v#{version}", shell_output("#{bin}/cagent version"))
    output = shell_output("#{bin}/cagent exec --dry-run agent.yaml hello 2>&1", 1)
    assert_match(/must be set.*OPENAI_API_KEY/m, output)
  end
end