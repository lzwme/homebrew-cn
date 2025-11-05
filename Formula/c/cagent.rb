class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.9.9.tar.gz"
  sha256 "e6591bcc7f6d130222d4f3564d3c5f31658307cb397ebd2dba6308b025237521"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bea6c556cf3454d1421cac4c3e1b7ed34ecab40d2f4d95671f7dd9bcf814d15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bea6c556cf3454d1421cac4c3e1b7ed34ecab40d2f4d95671f7dd9bcf814d15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bea6c556cf3454d1421cac4c3e1b7ed34ecab40d2f4d95671f7dd9bcf814d15"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9618d24da244876d094ef4e106b47a07626bb2a7e04597c299d158ef53b2ca5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c590bf1bc0a5dc20b8dfd9758da0a17e15046e3e74b769df81bfd37b3c5cf9fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dc55e29368c31b31122658b03afcd8712720f0c5ceb4035bf0e09d8de7a1d2d"
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