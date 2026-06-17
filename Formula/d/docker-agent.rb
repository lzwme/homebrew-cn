class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.81.2.tar.gz"
  sha256 "a9f1ce878cbf3ab1609d656c734309d7b0f237b7c035a77237c426c517a8383f"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4a1c729fbddc0786c473431f454f18a24e5de08d7a7d442a8e25c3444c248eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85bc13c9515759571c0c5e2cd04155c831b42388ebf10db47839e0c6d12bbc9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa4006714d702e89b11d219fb9c4cd2739957af6b51d7b980e4f0b9272c1f27c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c178f61540b46b9edbe772964b53d72248f4f943f62e4dd6244216107b5e2f53"
    sha256 cellar: :any,                 arm64_linux:   "c78e20e37084b43d08dd2556a3340fea9542be14e2b939b46da35904093eb9ff"
    sha256 cellar: :any,                 x86_64_linux:  "85dfefc0a6cd37a8e2595f3a16f088762efc9af8907d6aa1b27371b75bc6e8a8"
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