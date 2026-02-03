class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.20.3.tar.gz"
  sha256 "0d7a49d09ad666b216a4053402c670a2ab586b1eafc70a1cd2eec433b8b6e4cd"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0189f225c29a8054d7640c9a319a756ebd000340b561b8fb1bf446cc0bf5ccab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38a99bc789577c71be3f10e9a0184e13aa4e4da67808d3105721a55c88ce2192"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7e97e1a463e8bb1e8c7bc6fcf21bea0d3d25654523e6bccc62d98caaf299bfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec36caaebf9f993bb49968eefe584b346d2999d281460433740db83cdc608ba2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15af3bb59566857915d948cd2b75216701892a20b28842a8c46b469a47c6209e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ec94cbeab6b402c69e5beb387f54facba197cc75c66bc37760552d69bd4de6a"
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