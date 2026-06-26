class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.87.0.tar.gz"
  sha256 "d99b41199f6988650214c9a8dea8e7a1acaf76d081683f53ede69626f765d232"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1605a86b332b4b6de5e6fbd21dd5d1c0af1808b5752c354c691b6c5835bb79de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3a152f13f1053496a0188b351bc249f1b74f5077e36ae4da62a27fa529280fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d04fac168cf8ddde3b50adddb430b0b68af30d0e8d14227287ee57a7a9554a3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "361f6cf9e11b4ba9bc242a13c8fdc310dc109b5e8516311722c1248156a84991"
    sha256 cellar: :any,                 arm64_linux:   "1a378cb64735d65b083bbfee876b9611b17feaa22b5e4a77a6a6b0c5002850d6"
    sha256 cellar: :any,                 x86_64_linux:  "ee6e178c9772e3994e96e5c67c12c67734f16986500088a76345c4accec9cc3c"
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