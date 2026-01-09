class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https://www.openpolicyagent.org/projects/regal"
  url "https://ghfast.top/https://github.com/open-policy-agent/regal/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "d9535e9285ce883c8dfc190749eba7c20468ecaeb8d4cce2dbdd30a140fefa87"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/regal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75d3e39c69be2275fd72156ea62efa357b771966b2b2d5f5002c12bc45e7b283"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b09aee0ac36fe888cdc1de5ce1e648e90176a89717c62f9bc27fca88d5ada782"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c585ad63f5d086d23b2aa3e57f0147b216e65fc2ecd1f9276d142ba4ccc830b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb09deeb7e8093166aaa2624f1951f6c5eff6882ffd0a23c07373a180c35649f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c51a21960e7a96ee3b5b7f4c704ae76e849fa0617e67e35477fb0b4545f79313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6228b00f9a513af7c2e225ac374e7e97c3c2f11fdaca3aa7357f00344776a864"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/regal/pkg/version.Version=#{version}
      -X github.com/open-policy-agent/regal/pkg/version.Commit=#{tap.user}
      -X github.com/open-policy-agent/regal/pkg/version.Timestamp=#{time.iso8601}
      -X github.com/open-policy-agent/regal/pkg/version.Hostname=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"regal", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test").mkdir

    (testpath/"test/example.rego").write <<~REGO
      package test

      import rego.v1

      default allow := false
    REGO

    output = shell_output("#{bin}/regal lint test/example.rego 2>&1")
    assert_equal "1 file linted. No violations found.", output.chomp

    assert_match version.to_s, shell_output("#{bin}/regal version")
  end
end