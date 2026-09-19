class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.12.6.tar.gz"
  sha256 "1f33c7ded9e347212eb0f181ab41a008625c7a42292b0647c96cac2b4710ef0d"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e417716238f0dcd0a862c622854c2492b877079329cee0fa47686cb8ff7801ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e417716238f0dcd0a862c622854c2492b877079329cee0fa47686cb8ff7801ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e417716238f0dcd0a862c622854c2492b877079329cee0fa47686cb8ff7801ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ab6ec5f7c27357126c3de573a6a4960658ecbdc552b547e1bfffde241389d5f9"
    sha256 cellar: :any,                 x86_64_linux:      "034eaea0faf6f878e600f0905a376d02e062b42395de1fecc0b680edc5eebef2"
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