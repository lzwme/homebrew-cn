class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "85aeb44fb0507b538a257befe5660ad63647f2ed3ab1a5fbd1d9d31ef0a9108d"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9eb6bbb16480b54c3f1b3b8c0b2d7e683cc57694a19edcd2d6fa4900be5c11e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cbd2f4b36f3bc9a8683af9a9a711e94766df2204e87ab2a90a4754f22dcca8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f9686f1e5e583334febfd9ab05273174477ba6d676b4ef371abb561127c3fba"
    sha256 cellar: :any_skip_relocation, sonoma:        "925d4699e5502f933cb9820eaf8fe87ba10bd26f491864084c4c27b89efbeff5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95861c3cf71bc98d027568bfd31a8f1fa94a2ffccbd4475cd29724306d599b10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b614a4c496e143152ae5e73fba18cca676e6bce662b861a73e374a1f8b09cf4b"
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