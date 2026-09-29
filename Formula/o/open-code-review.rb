class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.12.10.tar.gz"
  sha256 "59e36dc9cc36dc9b2c1d611f6eee4223f60c540415602f90fdc58ccd4608de12"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e88ffd0520383b3eb03f649bbf23a7c36f201c612d3a69922a7e5a3f1e9bda1c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e88ffd0520383b3eb03f649bbf23a7c36f201c612d3a69922a7e5a3f1e9bda1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e88ffd0520383b3eb03f649bbf23a7c36f201c612d3a69922a7e5a3f1e9bda1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c4817d0522b17e514492e5726f1d420cb70eb4874a49319859d9051a1cf19b03"
    sha256 cellar: :any,                 x86_64_linux:      "750b70de943ed671b295f6d0677cc640c47da081a057be2d1e8d2e9df59bcd8f"
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