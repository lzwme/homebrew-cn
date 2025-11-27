class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.9.26.tar.gz"
  sha256 "0dbe61672588b268b0009d1e99224445b55576e630828abef5b378cef2d69b93"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63f9f9267279f370961e32fc4a0e73d67cfa5bcc4f17fc09e585517319d706bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63f9f9267279f370961e32fc4a0e73d67cfa5bcc4f17fc09e585517319d706bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63f9f9267279f370961e32fc4a0e73d67cfa5bcc4f17fc09e585517319d706bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee2db58d36f658da2480a01464d755ab399444ba2c542f75a749d753b2dbfff7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "387595fb101bd13d48ea47979ba4976bf23c990fb7847f07f962e946056c357b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53c53ea14f943e13941bccd6a5354d64aef4fb0465305497e706c57cf701b08c"
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