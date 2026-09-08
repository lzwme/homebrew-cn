class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.11.6.tar.gz"
  sha256 "a010eba8532b2f152fca6b96f01df3fdc85c5ce6e824d7edda72d31a8adac262"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "291c052758af40215fe7aba72624c402e86c9e83205d79c48db2ccbac38b389f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "291c052758af40215fe7aba72624c402e86c9e83205d79c48db2ccbac38b389f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "291c052758af40215fe7aba72624c402e86c9e83205d79c48db2ccbac38b389f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be16a0c9ef1065a2a7d5f38887fbd09bbb6e81b7caef9adc8c0ed706b1d9148d"
    sha256 cellar: :any,                 x86_64_linux:  "96c7259102bb9121b2369fd0bf2ce69cc50cbcd088828a942e791a9351ab77a1"
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