class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.46.0.tar.gz"
  sha256 "88c119a12dcbf218c064fbae13340f378f3a5f40d3857462ee3ff9ac1f35fad3"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "deeaaf4abc6b9f00aecb3e550cbdc167c4d5548c3a8e4821f252c37505b90ae1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "796abf0c6dc301a3fbff5266f7a0ff05aa04e61414182db183b29d2eabb29045"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fcbacb96868d984c9d3dca5b2dfe37a0c523291fbf6151ed8464dee8951e2ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "36fb33f71df0b91c62bb809f3cc21b604c1b9f453bb8e2a19d4cfa32d6dded18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbc47221beed951179dc27ef1501a589c082db07c6faa80daaeb59d8b59e6fc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f507b1c47ca46850d9c74793ab2d2c10899be319fd5d02899e29b45e4e37dd89"
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