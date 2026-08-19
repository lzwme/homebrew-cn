class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.126.0.tar.gz"
  sha256 "18ee5988ee2f4afc0fa3a2f40bada7208437255c5429398a5ee5d13ebe5b58cb"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "faba7f932f644110188fb5ff3c1113900ca5e36d9f702d1feffcbaa853ae9116"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30cd45ae2f868dc1d02e11af718d8a5e5670c1549fc859ae7f1089d28a2b4be4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fcce5ae0d5a074745c8cec3cafb6eb88eb320c7de0b69bc8f60f3df46321c05"
    sha256 cellar: :any_skip_relocation, sonoma:        "a365d30b26a4876803a8dcb758fc0b9a70b07c1e369e92502568fce6185a985f"
    sha256 cellar: :any,                 arm64_linux:   "1ee9f59539add930b176096d8cd91111168fc97299a2aa940cb39ed8949116f0"
    sha256 cellar: :any,                 x86_64_linux:  "f14f53e3f68e38fc3752bddb96d731af81175b404d99e4541e4934d9e3abe5ec"
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