class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.9.15.tar.gz"
  sha256 "ffdbc156cdf6d0c230ec908cb69a34b15fbc9c7fc8b406a9db9f016849110a8e"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "628a5fdd801718f40f6b060759d3cbd4d46021bb4c21e4e10d257eb40a651282"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "628a5fdd801718f40f6b060759d3cbd4d46021bb4c21e4e10d257eb40a651282"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "628a5fdd801718f40f6b060759d3cbd4d46021bb4c21e4e10d257eb40a651282"
    sha256 cellar: :any_skip_relocation, sonoma:        "72bb72c9805d89b6c1e1e05a3712f33c4d4f3a79f721e3f4e0dd7a75d8b9b357"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ecd037fd94babeebe5a46c30b8002b7cc0cef85193d94b90c0660da13fff943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6195320e2727880d6e0430e4c5b920c08584cc14f3a10c5767bb6bbe2ae3c26"
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