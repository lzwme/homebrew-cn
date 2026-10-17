class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "b4d11b6afd8e5bbc5f3f4bda19b84e2733be8c7a82cef302313f90467df79ee6"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ea3619b7ae9b0c5850bc23e4b07601d8bf21d17a18e57e675a7926541e3aea29"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ea3619b7ae9b0c5850bc23e4b07601d8bf21d17a18e57e675a7926541e3aea29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ea3619b7ae9b0c5850bc23e4b07601d8bf21d17a18e57e675a7926541e3aea29"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fc1975fa22fc17f37d348bb3f59267f050ce7e8338901705f931d3d19308331d"
    sha256 cellar: :any,                 x86_64_linux:      "3963eb3d7cba47ed4cf21af57cdbea5fb78780e3dbf15a9a8a8be95545f7e888"
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