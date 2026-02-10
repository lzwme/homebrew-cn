class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "cffcee722e69ecb8111fda9e6f8e6d46da09299a57b74f11982780a5ecd27e90"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74f79aa6e02a0c8f58c6a30b0aed357bc36a62f52713adc0ad01e7b7e773c61e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6974530eb354d3fca2e6bb77b5ef3230aec923d609e60b019e25b7ede3c41de9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75b6f56e8fb4a6b44a53eb5ebede28d1698abacc4a2a2ebcfc21a8c30d75252a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b299d6f419f538b333ac20dd337b21f8548b551ecacba69ac6773b47d8a402c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b1912177a0b40d80c36ff9bdaba6f44f366f4bc77a4733a77de156c90f4709f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c75fef5d3bdf9b7e07ca4768718f8aff9e1e1e22740e504795e669abc94d10c"
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
    output = shell_output("#{bin}/cagent exec --dry-run agent.yaml hello 2>&1", 1)
    assert_match(/must be set.*OPENAI_API_KEY/m, output)
  end
end