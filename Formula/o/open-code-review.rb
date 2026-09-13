class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "01b14aac6522199f04030bec0f2afa2f128bbdbf7bbebdfbc7758b8059a21999"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "468e34f781db3dd8d77fddbf9e52d4b490d2b5ff8c864b19f36044ce4c241f4d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "468e34f781db3dd8d77fddbf9e52d4b490d2b5ff8c864b19f36044ce4c241f4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "468e34f781db3dd8d77fddbf9e52d4b490d2b5ff8c864b19f36044ce4c241f4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eea2ea38895d3a352c54b2dd95a33d9bd5b7c5c40bfd11a69203c186659742b5"
    sha256 cellar: :any,                 x86_64_linux:      "62af3b379b526db05948fa8e0635c0806b601190de91d3d9cbf92dd352d8d6f6"
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