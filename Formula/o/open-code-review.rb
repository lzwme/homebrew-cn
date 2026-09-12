class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.11.9.tar.gz"
  sha256 "878f3601b8b603586506d3d86003dce34af74bf4c8f9493393e5b5ed57da656a"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0c3066a486250f30d78895f3c5aa847bad2e80976a32f3dd8c805b5af69497ee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0c3066a486250f30d78895f3c5aa847bad2e80976a32f3dd8c805b5af69497ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0c3066a486250f30d78895f3c5aa847bad2e80976a32f3dd8c805b5af69497ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fc7ba85b9dd7102e046cb631d0ebd6b3092d1923677cee48b5986c8aad08af4c"
    sha256 cellar: :any,                 x86_64_linux:      "b79ce3f9ceb1e6d53431b642e336599d066380028eefcba4d18cae7b9892694a"
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