class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.19.7.tar.gz"
  sha256 "38236349a5b22432466097bd3184e346a3bc62694a73de18c660cd493d68104f"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b69eb4d842d6d7e57ff6ecec142b22bc4dcf49558a6f9edfbf1aaadf9ce0cc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a73def62a4f782393b01d7bc5873a487904f956d184bae9214476bd92430b407"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af657cf6b4f4d2df3da50e1a285ec19eef58a5477c241eee89ee0ca049b233c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "060c6bef230c68abeb8adf32337284253063c34b1fef63cfa40205fbd816f660"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fc6058d7abf89528a58ec2af70ab0b9886496116345c0d38cdefa129f16c9dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fbd42bd8eb044456133170d022ece1db76819fce067e636a7a08b6d31786fa7"
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