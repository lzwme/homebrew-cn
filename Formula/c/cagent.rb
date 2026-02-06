class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.20.5.tar.gz"
  sha256 "a71f8636e7e93f291807b5d816fbd0735be4a4912dff515582da550fad332940"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43262d51f79a0595649596ad736645d35ad1c3c3428cac94a2637135fa01afd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e052fe10fc9f2ab317959b924a7e45a12c7afaa22712da05de5dcd81342f75c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50aa8a064b4f87b4fb3c61c4cd7bbcae00e0f4b82f35e5f8850468d5f5f9ce42"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c89a9ce7d69a277c4e44f065091b55c5532992b77db00fe35b78f6396ec5205"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a4652d095a099b8e9f74c1a9ba2290d69d180f5d42c74e420780eea919edd0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b4e419bc0b9f67d393d4c9f599a339e78a0b4fce58f7a7be3b632d035ff0e26"
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