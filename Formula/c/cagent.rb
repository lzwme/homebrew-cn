class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.9.24.tar.gz"
  sha256 "4f1716e412010e21369c93b7fd62af17730f906de37c6f4d0429e3eff66c05bd"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b291454f33716268314fcb295ee333ae68d8f5a02a67aa326ca0ff1c9cf9540"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b291454f33716268314fcb295ee333ae68d8f5a02a67aa326ca0ff1c9cf9540"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b291454f33716268314fcb295ee333ae68d8f5a02a67aa326ca0ff1c9cf9540"
    sha256 cellar: :any_skip_relocation, sonoma:        "8537311355b7130f22bc96a9a1995dd75a317415e0d3de679a0da4f295c6f830"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf7a00a737cb18d7556b9394988700c3cc6bdf7501f7ce1d9b6f0f0209af461e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93127eb4c5251b5df75d4e2f5b6a6a717f3ae39e975dd40d9aded9c01c6c5a33"
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