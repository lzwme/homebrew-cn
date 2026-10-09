class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.12.13.tar.gz"
  sha256 "559576cb9eebba315e3c26ff03eeadb741340d22b4ba2463ed5bae796563a12b"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8955ca64a4b683e41a53f4e77da73d95ec3013a14076b886080e818bcf990765"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8955ca64a4b683e41a53f4e77da73d95ec3013a14076b886080e818bcf990765"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8955ca64a4b683e41a53f4e77da73d95ec3013a14076b886080e818bcf990765"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "800e8086bf82bc44f540cd2f3be6a4a01e5bc11688c3c4708ad2b1f605e82e84"
    sha256 cellar: :any,                 x86_64_linux:      "7968f5caec82cfaf911bb3b6d6019a33ef72504ef4a96b526c100af92c0bed21"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"ocr"), "./cmd/opencodereview"
    generate_completions_from_executable(bin/"ocr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocr --version")

    # "rules check" resolves which built-in review rule applies to a file.
    # It runs fully offline but expects to sit inside a git repo.
    system "git", "init", testpath
    (testpath/"main.go").write "package main\n"
    output = shell_output("#{bin}/ocr rules check main.go")
    assert_match "File: main.go", output
    assert_match "Pattern: **/*.go", output
    assert_match "Source: System built-in", output
  end
end