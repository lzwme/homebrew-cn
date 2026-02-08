class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.20.6.tar.gz"
  sha256 "043b47065dd6fc25e610d88082eedecfb7cb935a22f43cf50e1812d5284bc9dd"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c1cce6c5229516b1b9a75bb88bdd5f80e23c8356cf331828f69ce4d90e201c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1eb19d3ddcb641b01ce5ffe971d7457ed78b8e37c65ba885679d0c2a86e5db3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f43cd67e29cf67384d550568a52c4408f31ae458c1f5775d4c0e6e8f1716c441"
    sha256 cellar: :any_skip_relocation, sonoma:        "de8108035200c5069a2f58bd2c0b08e29ba4e1d63ece2fdf11682291ef072461"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f3b3a9f806e48cffe81f2f9fb71392fa559b092a9e1f3a2abceb46cefd3ff05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ac39b718a7154a83615fb6ea00d9d067a1dae32f7f7e7c7f5b04a53e193018a"
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