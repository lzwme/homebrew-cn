class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.9.12.tar.gz"
  sha256 "ab45a4548331e32855a1d5af566131c9ae86a549c7fd0722deabec5143281bec"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85baf98a45ec83869f4c523e0c091e58bdc0aa446d2c4d11170025d400ffc093"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85baf98a45ec83869f4c523e0c091e58bdc0aa446d2c4d11170025d400ffc093"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85baf98a45ec83869f4c523e0c091e58bdc0aa446d2c4d11170025d400ffc093"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6863516d7311cd37867775a5be023076904adf61968c42e866ea30e7ef5f101"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaebdf8ca107be30e0cb3fc81e8623870ba3bd760666815809658c4ac6bc9271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ba46f43cb12cc1ad3ce773f6c07df5e6faf742284a7b2bda1fd0e2960f7c8bd"
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