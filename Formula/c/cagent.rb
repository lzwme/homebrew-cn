class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "b48511c371c8efda3d31769ea5ab14a138ba9970ddd77ddd684b3b23311adbac"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa391095de186726ef90a492911f1304db86af0a0083489d8967b5e9b4f32d00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa391095de186726ef90a492911f1304db86af0a0083489d8967b5e9b4f32d00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa391095de186726ef90a492911f1304db86af0a0083489d8967b5e9b4f32d00"
    sha256 cellar: :any_skip_relocation, sonoma:        "268a84e25d50dbc63d0e8835a35ea712971b96bca8ec0fa178113232c4b5a83c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ef065ea873df2fe54f0261ce787daa40d4537c7e6a256ae6147013376dead27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae77b7011ffde3a43b44cd569ee44fedcfad9d631fa7191a8493786280990977"
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