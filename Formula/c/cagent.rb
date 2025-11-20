class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.9.17.tar.gz"
  sha256 "2778c0676b80129f4a9319b517b804d03f67def92aaf522b934946c26fef9dfa"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46c43454c3b655ef867a5ea214fddfd958230b2037737955e64da851632e709e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46c43454c3b655ef867a5ea214fddfd958230b2037737955e64da851632e709e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46c43454c3b655ef867a5ea214fddfd958230b2037737955e64da851632e709e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f4a651d5c06f3a46abf9af019c3858a38d6a3563845ea221a051ca0c4113924"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30663690b789800c5dec25dde74c79b5ab30fae2b5b9376bcea6c91ab68fe231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "160565f431bc2b8be9f45e424bebc96978668ff86856a572a6337666b7a177e8"
  end

  depends_on "go" => :build

  def install
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