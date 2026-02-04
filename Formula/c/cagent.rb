class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.20.4.tar.gz"
  sha256 "58776480135676c41bba719b65a3022701144571786eef655d90994942df8217"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6c74eed3911a6f4f7bb1bafb7acb99ced285aec9a7095bbbdf167a7c72e386d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "777c92e14a77b9a4b34790454d53816a6309665e55274b3783782f59f7aff8cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8bc3b88d1dee5a9be766ef851aa57ac7d2bb221826b6e04f5d96322f193ae0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1246113550863bcd1ec7d90be682e7fd5672e163e4598e1e1a94f90382e8a724"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6329fbf835817636656babc35fc42eddf75cdca8414a3622607101baa7c2bc40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd332472d87ec623197840755da7c33077b1428ab207babaf56495a449d225cc"
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