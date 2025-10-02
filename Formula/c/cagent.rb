class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.5.11.tar.gz"
  sha256 "9b11261f7c946d591010eb1d799d045f649c4abf7ed57f53a98cac756374336c"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "447a46fb9a347e103336505f78a2dbdbacd5e615e56b5b6871b2010a23676880"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "447a46fb9a347e103336505f78a2dbdbacd5e615e56b5b6871b2010a23676880"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "447a46fb9a347e103336505f78a2dbdbacd5e615e56b5b6871b2010a23676880"
    sha256 cellar: :any_skip_relocation, sonoma:        "d62fb4ab69b2c24a99d76fe7bd67e029a3e9cfe2c16fe41c0e3ad8f4e949e408"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8729b2e6df0e1c5436db62e9fa043e0a14df57ea7423c892bb25322d7f97a88f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0f55bafebe5c29a90dba8d6877f4229668620146fdeb51726f238eef06a617a"
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