class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "b7165b82f18b1c8e7ebb5415e8e62945086c8849c415d9f134fd85125491da82"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8ab1cbf9f7a91dcf842cb4c43b6f689525a32cc24c21d4058384bb96e7d241f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8ab1cbf9f7a91dcf842cb4c43b6f689525a32cc24c21d4058384bb96e7d241f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8ab1cbf9f7a91dcf842cb4c43b6f689525a32cc24c21d4058384bb96e7d241f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5795861954e1a1166a063c89bda5fc94d0b8593a0002e762d7ce747cbe87d73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeeff04feb7649a7c32052c0f5dd70c12ba28e5f24117a31f6574aa1dd5a78e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88f8499faba0c97f2bf3f0e971fc3d6382ca7cacae8a1fd197d3f2e7150913e4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?
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