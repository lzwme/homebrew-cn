class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.7.tar.gz"
  sha256 "ef44069f812102545b15404b5dc40a2a8c9c13508ff4ad020e1d4a69c851465c"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bbb0f0965c40c9af916e9b027bf3aa0a51c4999b6fcfe4b84ad3c6bc8ad8078"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bbb0f0965c40c9af916e9b027bf3aa0a51c4999b6fcfe4b84ad3c6bc8ad8078"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bbb0f0965c40c9af916e9b027bf3aa0a51c4999b6fcfe4b84ad3c6bc8ad8078"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d574fff19a55296b95339ce817ed0b68272e35ede34ff72eaafd0987f0aff71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "152a1d1fa6844f59e6b35f91cea2ba167a5164ccf321293119d4f5f28f73a762"
    sha256 cellar: :any,                 x86_64_linux:  "2a2083c4a180fe2a15982b2c3a0afc58d4f0bd713692a5b97f694f4277563c7c"
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