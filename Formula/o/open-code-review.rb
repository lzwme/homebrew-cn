class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "975c7cfb099cc824bc6000d009d6535580c81db79d6e395a2a40f17f4fdf142b"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a110dc81d0b83a6041df847bfbdc7a4557398d8fc80c1bbdb9eab44083f2bc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a110dc81d0b83a6041df847bfbdc7a4557398d8fc80c1bbdb9eab44083f2bc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a110dc81d0b83a6041df847bfbdc7a4557398d8fc80c1bbdb9eab44083f2bc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d17c0489b6418dfcf2a7230b1ea99403cbefbadec36338671898bb9358f17e8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2136f4ae67d3d1dc7ec65cb8d5bc2b950bfe430834d6bd7710e8d1180668f09"
    sha256 cellar: :any,                 x86_64_linux:  "a022d835b31a21a7dd28add82166ac65146e744f407d407677d1dcf8ee286c03"
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