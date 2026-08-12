class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "dbeadbcfe1d29c63e4adb21a4a6c1885b1d234b7b530c8f5ad9a47f419b4e1e2"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "569d9cd0a2ac4c020fe9455ed3c04141d05857e305e77a43c24aa1ef21aa40d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "569d9cd0a2ac4c020fe9455ed3c04141d05857e305e77a43c24aa1ef21aa40d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "569d9cd0a2ac4c020fe9455ed3c04141d05857e305e77a43c24aa1ef21aa40d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c198af045b3c4f285f11aab59d789d35a791965764306d3376089fff085d7e07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "859d87c24c9be40558b5d26d69b801002e32f76fc7733a13c7c305978648ba13"
    sha256 cellar: :any,                 x86_64_linux:  "2dfb24af557e94752554a55d9ef39f35fd96baf15fa3ab00a32b74ced52ccee3"
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