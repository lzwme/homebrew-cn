class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "9f834e916b5038bdbebba4dfd18283e2ead1648d305c894aa87520ccb8e875b2"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90308ef70d29d5db407ed434052286a4b1aa7781c96a9b2c6f5c15d0168dcb93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90308ef70d29d5db407ed434052286a4b1aa7781c96a9b2c6f5c15d0168dcb93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90308ef70d29d5db407ed434052286a4b1aa7781c96a9b2c6f5c15d0168dcb93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b7575b02bff57d1f6d6fbf25b888f07f8a3ff6f4a2b4926f27814210d39c0b2"
    sha256 cellar: :any,                 x86_64_linux:  "346ee73daab10f33faa10e0c6af2d140955e35c590343e7d6b35ef56a67902c6"
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