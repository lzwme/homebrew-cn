class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.8.9.tar.gz"
  sha256 "a57db446fd58b80ab29a9ebf13b2ad43e3926ec00690bf94ec49bd7b0cbf26f2"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cb88e6c12ab26a74ef86f83fd1bdeb0729c1f35fe63d4f82c092e54e8ef5bc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cb88e6c12ab26a74ef86f83fd1bdeb0729c1f35fe63d4f82c092e54e8ef5bc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cb88e6c12ab26a74ef86f83fd1bdeb0729c1f35fe63d4f82c092e54e8ef5bc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "59d7ffa73af68a665d0f47317275708cc46dcb6b50c55b92199437f01483a906"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f488622cbab0e572247058f3bd83592b56258554bb7874da28ee40868bfabd9"
    sha256 cellar: :any,                 x86_64_linux:  "45468a4602afc3066de3f0ff003c92c937ff44c5aace41ff43c03042d8484500"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"ocr"), "./cmd/opencodereview"
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