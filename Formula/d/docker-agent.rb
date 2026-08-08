class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.123.0.tar.gz"
  sha256 "cbc1a4cc674c7a044c50d776ac3872f2f598c5a1fc280da0698a3db3b6501b96"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70f5bdfd40d44194e0088f9432708b8a0561ae9bf110715f7056b79474b84bec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e53087df5f4705329303a7cd060e1476d55e5ad591dd6e21273c79987fc6f6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6836e2476ac1febd071d3b9c304730e9fb54761b8e26f98e12c7a8ed60c953e"
    sha256 cellar: :any_skip_relocation, sonoma:        "68b297db3e199b6c4376862fa727cf6514659603a7f0145e53dbb01bd9706ff3"
    sha256 cellar: :any,                 arm64_linux:   "232d946ce02c8ad7b3b25753e1f834599b910f2d134a3822f63f2ef48c1f6660"
    sha256 cellar: :any,                 x86_64_linux:  "fcce80e5da3e2420f5329cc089970c806fac43c9f13da252da5c2165854d7453"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
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