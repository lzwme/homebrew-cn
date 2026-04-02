class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "8596045c806b6213c8c088a5f3bc7ec53ff3e4401d96ddc8c5508f7517a03c2a"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c69751e3a48385598aef73527a25c6e19264936b097cad8bd4f4d3cf40d6e93e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eff65186b2c89cdb626a6d818040ef57017d1d48809d2393ce01778c7ee112d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3266006ea0fab5878c8acfb3daf176557fa2fcaccef1d2a652dd2bee147c48e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "210bece1b2b6d77f62599fdb87af2794ba3d876ae102b84a6755e4f217d0da7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2a2365b1870bf066ae4ba8e5fb450bb2c35c1812722abd0af861e3bc6ba87bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44550b25528eaad75456f9847de4346b34034d2d602fad7815a4701c6e2b60f4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/docker/docker-agent/pkg/version.Version=v#{version}
      -X github.com/docker/docker-agent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"docker-agent", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("docker-agent version v#{version}", shell_output("#{bin}/docker-agent version"))
    output = shell_output("#{bin}/docker-agent run --exec --dry-run agent.yaml hello 2>&1", 1)
    assert_match(/must be set.*OPENAI_API_KEY/m, output)
  end
end