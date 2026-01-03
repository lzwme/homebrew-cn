class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "41625d5974777f133aec56c7e4861117d39769c66ef67ad3bf23fbb3d966dd56"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46de2f7eddf3ceec6e4b303c20da5a24cdf690a9c52b62822e3a25cabb403f04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f17e06048467c7ed67f119ddb01b4b5c1035175d4354f8df6a96785e19dd6262"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f096b9d75c8a86c5ddf667f7d9111b240ffc5da0a952fa7bad5d5ea9b3e97c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "abc34ca879dc68e789fa733aa262315b2e638dd412113aedc5083536eae10f64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeb9102f8e266b69ab64c1cc05dc3e08f7d704dfa7e198649fd06f9f4dfee191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87473dd9f819b1bfa8903de7648f333dc50f4dd3e2a987cc4a768226b7a0bb3c"
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