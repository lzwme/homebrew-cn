class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.77.0.tar.gz"
  sha256 "3ee8ba0d45523123de6a29c4f7748d37b8d96c8daa54efb430dedec7720fe38e"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5991377b99566dc4569be2fff1c3160a6e8af9fb25f2a1df1526cecda251b54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d19070c4dfe8b2c645da5b5849c530b5b49848961c2e42bb636e5b080674ef02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5426d942e1200aec61e78f4da65d2b1e9dc9d2ba692ed64481d51e94c10dcd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6305f4ff793bed35bbf289e27ff26e7c3a1da58a55cc4babeee14cf4e6f16a4d"
    sha256 cellar: :any,                 arm64_linux:   "3d4de11e088ed29677cb05ed5ce97481639c9b829083a78723e7bc39c0c61488"
    sha256 cellar: :any,                 x86_64_linux:  "f86c314fe9dbef22443ee78e0c82ff010325e7010b3ba8dd5781535c7478c946"
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