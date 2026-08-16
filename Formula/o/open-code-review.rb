class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "cf948a888db50936492995e9da72320457ba0aad2add9180f2635930051c7a52"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70590268142f882cb08273b4c3bbf0f903a0fc9bf00cf8d0b5593851d6038f80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70590268142f882cb08273b4c3bbf0f903a0fc9bf00cf8d0b5593851d6038f80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70590268142f882cb08273b4c3bbf0f903a0fc9bf00cf8d0b5593851d6038f80"
    sha256 cellar: :any_skip_relocation, sonoma:        "23689325dbb221526160d01965a0b2e03eede5f70bfd1a713aed6271b861863a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "804c1d4a9deec2af4f72eb0ac9b47c756c97cdb415b7b61fd059bb369d6a3a1d"
    sha256 cellar: :any,                 x86_64_linux:  "8991b8a180aa2bd5fe7806bee83c80fa7cabd3c0067ed6eadd6ef114ab3e8904"
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