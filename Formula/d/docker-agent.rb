class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://ghfast.top/https://github.com/docker/docker-agent/archive/refs/tags/v1.53.0.tar.gz"
  sha256 "8e97249c814f30dfdf84dabb0a7be8ff37df9bfd35d099f781c064620db1bec5"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f580758b0dad6e4624288c03afff906abb3fc72226bfd22468ee78136ad15f93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39160d1ce66be31b4dc36889543218531ed19d2616ed44c6b0686fe70c824a09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09dd20aa7fa22dabe23dc9e50e7a55743d231d1125ae86985575074eb66f0e06"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fc4fc8ec7347c2450ee9fb2313fbb4fb0321b4f6665a36319c92d69f81ffe58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48b23b5ab5ceef09f2a02c6e0c3e2b1841566f9db95beadd4644b761c7e4f6ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41b4ccd2154fba8e7e3a4ab58cbe6e0e85007878d12899dfff8f57f74eb97c22"
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