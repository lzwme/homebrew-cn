class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "6bd80ab7e3cb607ab3255608b6d13d9c5a39d04e00b629c53e5ee8a9754a6366"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e68fa85a96abeb5a073e0fcde0fa8098926bc696e1b19642a7f9d2113801adff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e68fa85a96abeb5a073e0fcde0fa8098926bc696e1b19642a7f9d2113801adff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e68fa85a96abeb5a073e0fcde0fa8098926bc696e1b19642a7f9d2113801adff"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d4034c3eaf97059440641231ab9b9549c576ca8c57be91967edfba1ab9d1d64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c95631697594dcfeddf59da4dc5acf1e5d5cc7e6aaa946d165c2d1e9173b1dfb"
    sha256 cellar: :any,                 x86_64_linux:  "5e66861aac70f450dd67fa15007d3a5e635510298a62f25b846d8eae6421216d"
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