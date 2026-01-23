class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.19.5.tar.gz"
  sha256 "0568866621cd358c3eb09bec03c55f2e0ddfe844ffc9c6353e7cb54f58f6ee80"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6716ad183fae25cb31800fc62b6a6968c0fc1976b07a70f20997b7d4c49242e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cce7e78ca3ca2d02ecb0e8874dfc6769e6a9e9a79ea0dc4c4316c647de0eed6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e8fa1e6abee0bcaec8af32137173c9d6d4c502df9dace28a8c116d08272156b"
    sha256 cellar: :any_skip_relocation, sonoma:        "04f65507456db66ee1284f35c7db2c50d00da2ef56d4d561a3b9b28a0445d5d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98d1fa53bdc73ade3d3568d01a22c0dd4ca746d02227a80c8d8f4e44c4450a57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "792dc255e52b4c2c4b77bc6170f82a1241c1e1b443ecea1c843e1077e742631f"
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
    assert_match(/must be set.*OPENAI_API_KEY/m, shell_output("#{bin}/cagent exec --dry-run agent.yaml 2>&1", 1))
  end
end