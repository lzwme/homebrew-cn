class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "cbe3aaf985ab6536976c05ca1ad76455bbd460abf3198fbf36341e724b7bf8de"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce3d3f35178b0aa53b98b63d4ef8fd7185d4090b9a706d346a197cdc78cd121c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cbead39f6de525c6004bc6cb8b1acbda152aac8e67cda7ba2cc6ed5f4bcfef6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b4f361c9de6cbb6803d082ef48c285c96d0fa84ed6e7eae940e8953878de3c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbb94ae00051a0f9f6b85636468a2681fdfd744c9097d228e75277a5e47bebe5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb5144e6a8c919d0cc9a2adde2a593f8a575eeef94858662b0244ba30645949d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a00896612dc63aa64e5cbe021049d22d1e343a1eb27c0d8884c06d06a080ea97"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/docker/cagent/pkg/version.Version=v#{version}
      -X github.com/docker/cagent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cagent", shell_parameter_format: :cobra)
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