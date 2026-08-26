class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "04e7faf368911a75f45ed8f3fb431346d86ef52da74927d7f6906d89ca081f31"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "312efb556fa748d6a03fc68c04327d52d6ead9a0a54ceaa4a0c7685f247eb36b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "312efb556fa748d6a03fc68c04327d52d6ead9a0a54ceaa4a0c7685f247eb36b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "312efb556fa748d6a03fc68c04327d52d6ead9a0a54ceaa4a0c7685f247eb36b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8fa003fb2e3dfaf17abc8bedd33b100af4402d635cbef62bc0d1b25719be0c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7d8f1f49f54aa3b6a31036437f403c1128bf5c86cc1719586fde44952943849"
    sha256 cellar: :any,                 x86_64_linux:  "ddaa37fda3ed2e086168f8ddd3352d9c65065585a3f92ac2ed89333b5eda1ede"
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