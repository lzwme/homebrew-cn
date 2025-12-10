class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "e9fe310f5476d981502f241076f2acdb83326ecefafcfccfeade8863ead43b2c"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37e31fba9b940b3a55ffb88a2be853924131e8470b7f0ac08576831378204925"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ad3ea95470465852f9d91bf5325a59542ad55e708509b3397ab30ff7f775a96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cef1af6c5ab75e79304c42a7ff65899995e244da21033b42d7f57f835d63a7dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "013129c638e3b0fdc6e49d0902572eea069d274234aa85e666915be931cf045a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1904614c4e57ca0cb2ddcb040feea738b4befe20f2acabfaef26117b2e677c67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdd156a2d6ddb9cada31c7f167ef79e0c20f37045e22d9fe6b2406c3f639e030"
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