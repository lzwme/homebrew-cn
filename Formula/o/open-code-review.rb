class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.12.4.tar.gz"
  sha256 "2046da3cf30a4b672236c66f707d02383de5792498a8e6d7b9fece6be2c212b9"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "22df6f5de76c536e5e7213f558c0c7f9e89b71f13e60cee2e8106a2a4dc57f02"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "22df6f5de76c536e5e7213f558c0c7f9e89b71f13e60cee2e8106a2a4dc57f02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "22df6f5de76c536e5e7213f558c0c7f9e89b71f13e60cee2e8106a2a4dc57f02"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f9755716608e24e4245ce0eb0301768ecc4b922fa7afc0313f215081da55f36e"
    sha256 cellar: :any,                 x86_64_linux:      "aed706b387ecda9cc8322d45cd64e48a8dc27672e13355013e3fdd100b5342a5"
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