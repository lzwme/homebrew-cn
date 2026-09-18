class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.12.5.tar.gz"
  sha256 "518f228fcc13c09d2e85ddef6db4d84505f081835b8dd3934f0054801f72017f"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "627d49407cca90adf104f25205f2c4cd1a7b6f75921bd0dbb57bf846e7ced884"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "627d49407cca90adf104f25205f2c4cd1a7b6f75921bd0dbb57bf846e7ced884"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "627d49407cca90adf104f25205f2c4cd1a7b6f75921bd0dbb57bf846e7ced884"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "577811d9d40c71337c72c9ac1e083ce83663e796a2035e4e5dce2ce58ad9d341"
    sha256 cellar: :any,                 x86_64_linux:      "1b1fde6872fc65501892466f03e0bf2adae49daf1e3cd7e2472c8abb92aedbdb"
  end

  depends_on "go" => :build

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