class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "871a9e487d8ae15b725be0f70ec157e0f5473eb96048e4cfd1d1fffd24887c99"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78e582649eddd74eedd41dd5c6322409f5f3374b7c4f1941f62614f703d72466"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78e582649eddd74eedd41dd5c6322409f5f3374b7c4f1941f62614f703d72466"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78e582649eddd74eedd41dd5c6322409f5f3374b7c4f1941f62614f703d72466"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be0145123e403e9d0ce9973e16760d677e65dde9afdc71d62af23cf2c5244c71"
    sha256 cellar: :any,                 x86_64_linux:  "484a0f6e66fd571fee2c2d235894cfc190b2c884ee087f51f5a908a524496252"
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