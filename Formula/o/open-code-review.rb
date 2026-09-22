class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.12.8.tar.gz"
  sha256 "07ac04d6b2f3044b05e324ef29a697d260d79f408a349e05257d64d628e1c587"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1eb3ceef91a8efcdaeb17e21d22209370fc0bd9bfb42818f58caa51cbfa191b1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1eb3ceef91a8efcdaeb17e21d22209370fc0bd9bfb42818f58caa51cbfa191b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1eb3ceef91a8efcdaeb17e21d22209370fc0bd9bfb42818f58caa51cbfa191b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "181ed38753b3f8bc1b195dbbff90c5c37b19e4f39877e3e373759b9fb37b0d91"
    sha256 cellar: :any,                 x86_64_linux:      "ad0c74c339f7c599b3c7587c450bb86355c35757512995db4bd2c7555a4910b2"
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