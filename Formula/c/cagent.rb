class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.10.6.tar.gz"
  sha256 "f393e4ff8d93d048c51e5908801fd0d60c28aeffe5e364655dc048a26dbeae94"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a562fb957221528e20d85fa9ff69fafb7c590b6b5c8a71ae69cae13b43192b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bcf4b3bacebd01f440e9133f7077761825548fba4e1b53433c1dcd6ebc81f57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9c706e9e9d7c465d70b6f63344319aa8cafaea7a2dc054ded15aee2aa327afa"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4f08737fb916927a226acc8088e2eb5e04a69b395042264eb18e224581e14bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4143a5856a28826770267f32156afedadb1e8be186e15144463ab1507b63c14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c62896d8d7bb42153812117e1efdf18eeae8d03b25bb3c98d9d61ba0235b4ee"
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

    generate_completions_from_executable(bin/"cagent", "completion")
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