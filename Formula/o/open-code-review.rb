class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.12.11.tar.gz"
  sha256 "6f27af5bcac51437b726bc8b35bbc341b52b26a62b5bf2c74cd87a0e5ac19d65"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9f7a89b62d25b86406b1f0b6751fc85213f35bc485fc5cc4ff072de19fa8f86a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9f7a89b62d25b86406b1f0b6751fc85213f35bc485fc5cc4ff072de19fa8f86a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9f7a89b62d25b86406b1f0b6751fc85213f35bc485fc5cc4ff072de19fa8f86a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7b097c351351f838521667f3118e3864b1c89217614a2c1f66c738f34899ebba"
    sha256 cellar: :any,                 x86_64_linux:      "67bebdf109c543ef8e3802d2ff4214d7b354c3a04d14fc5b87db089019db8c5f"
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