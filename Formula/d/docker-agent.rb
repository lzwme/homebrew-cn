class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.65.0.tar.gz"
  sha256 "5e7c23d0692906cc0df66501da3880f25b30ed93148f5b7658b1ab100a232282"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9efe00453e736a071d2b15a3bcf622b5b632b9e574aec19e65c3c952bdee95c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61273d71bfb8a132fe7ff5dfd611a1075b0a4f6e90d8e62f777a600e30f9cbbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e401fd5b656784190f969eba127eebe696d0e739e923adfde4549588093cc14"
    sha256 cellar: :any_skip_relocation, sonoma:        "b828dfac714bc731c57553f63228024765763cbbe2228e15b3426457a3da7afb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf38aaff650d6f9683f6634d94e5737295b7c8b690a0207585094ad5579abf71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "707f1051f4514fef48c7ad5783a9ed316b5ff975479da42134d43b806fe99a22"
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