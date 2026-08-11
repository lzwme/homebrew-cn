class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "47936f882ebb069fbba9d326fb63cf8f3778dd55c1b150b378ac885c33469d53"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c778c93ff0c2c67088cd47569180fc1a3130413dc12f19829391809c5c89b18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c778c93ff0c2c67088cd47569180fc1a3130413dc12f19829391809c5c89b18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c778c93ff0c2c67088cd47569180fc1a3130413dc12f19829391809c5c89b18"
    sha256 cellar: :any_skip_relocation, sonoma:        "90a1e993929f675781eefd549d0a39b1a08130c8ea36a218991f3a25cb627b8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0da76d3126b527eef3ceae0dfe035ba6a7ec61a0c850d7091386682104f2fb0"
    sha256 cellar: :any,                 x86_64_linux:  "4d91752af2b9345d624b5374d915c8dd1e1b62d7c42e40ee34e1983fcc9f6b10"
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