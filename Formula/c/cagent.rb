class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "404da4abb1fa05756d1fc9e0db185e4cd64fda745183a19c685965ccccbbaa40"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b5f16884663d0976d5b354fd54bd79c287ce698480aa36aaa6ee8f85f361340"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b5f16884663d0976d5b354fd54bd79c287ce698480aa36aaa6ee8f85f361340"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b5f16884663d0976d5b354fd54bd79c287ce698480aa36aaa6ee8f85f361340"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9a95e14c8a90950e4548556bd19c637ed2bac12549c4df8c35c4a94bdf802fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "563fc90e7b2454c39e046c590a939848c580c1de0ce5dbad26836914d34513d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "722f5dc92e754aaa8299ff23301a5ea6621eefd226b4a2d3edaa0abdb29cb5e9"
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