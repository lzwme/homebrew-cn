class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "7e49d97ba752f71001f9bab548086c2ae8d98c103cde4912a5d9ba67800a66e1"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee93e488c8a186b007883df6e0edbb0a2fb2934a2f62015ed1f2160c7364e3bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee93e488c8a186b007883df6e0edbb0a2fb2934a2f62015ed1f2160c7364e3bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee93e488c8a186b007883df6e0edbb0a2fb2934a2f62015ed1f2160c7364e3bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddf56d89047ab5c303bae12a4d5b305c1d45885ab026a315a4fe19cb1eaccef5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c468c5c3805df56e2f4f811a6e87f5f09108c865e0a754528301f098c3a02beb"
    sha256 cellar: :any,                 x86_64_linux:  "c3283dbedc072e9c42ce377eea878705c2d1032f2b0925d0e6058a3552fdc06b"
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