class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.12.9.tar.gz"
  sha256 "29ca53007ecb9aaa350a95975f620f672df97ac01599246d10b3549a9652ebc1"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d89e3b5693ae4c71a55dbb6240b08f3a2e3daa9dfe8c0c6499d3e5bc43f4f521"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d89e3b5693ae4c71a55dbb6240b08f3a2e3daa9dfe8c0c6499d3e5bc43f4f521"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d89e3b5693ae4c71a55dbb6240b08f3a2e3daa9dfe8c0c6499d3e5bc43f4f521"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "232856bb6b885b32760610731fc615b64e3b52afbb3fe7aeb8dce8a24fd813f0"
    sha256 cellar: :any,                 x86_64_linux:      "e65a05f00a7419a55cdc3e629c25864be74a9cdaf1c4244c844244a40aedafa4"
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