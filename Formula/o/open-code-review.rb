class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.12.12.tar.gz"
  sha256 "17df81a6002fe8b2f9cc9319942287e130da656e6660ad909cbf3e71b880bfd2"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f3e64cc9cc0290cdb70a426549d36e7ca9f8163cdfa5ab887994428d40955443"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f3e64cc9cc0290cdb70a426549d36e7ca9f8163cdfa5ab887994428d40955443"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3e64cc9cc0290cdb70a426549d36e7ca9f8163cdfa5ab887994428d40955443"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5a2e0d8b431ba5c4d5bedc329f85f1cc94b279fa3b6c137e9898cc037cff90ee"
    sha256 cellar: :any,                 x86_64_linux:      "ad3d91fb07f3e531822c568244d615afae2e7b27e0015a21acbaaf8b5cc885be"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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