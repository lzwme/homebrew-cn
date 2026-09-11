class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.11.8.tar.gz"
  sha256 "a20176ea8e932a7bdaf774b30055593aee62e0f8108d336a003bcce72bdad1a5"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d6dcadec6cc688ebafbfbe9dd5c1df56efce12a25b943c5ecc6791f275c174d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d6dcadec6cc688ebafbfbe9dd5c1df56efce12a25b943c5ecc6791f275c174d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d6dcadec6cc688ebafbfbe9dd5c1df56efce12a25b943c5ecc6791f275c174d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6b4f1ad3f0d8a2a53af2f026286b6f53a869a67a8ac05f17fd1778e02dd095a"
    sha256 cellar: :any,                 x86_64_linux:  "b9929c28f0dd4edaa9166b7461fb9b61421a8c3e41e7f14005d8d987aa9f4a55"
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