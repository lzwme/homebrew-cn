class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "c15029d280e758ae5f3f9db88deb80a6cbc81f1e3a7e3eb5d4fec15f8d25068b"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b27f03fda383cc816d445a3c97043a40e70f3d66ab748d8f3564fcd710c797b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b27f03fda383cc816d445a3c97043a40e70f3d66ab748d8f3564fcd710c797b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b27f03fda383cc816d445a3c97043a40e70f3d66ab748d8f3564fcd710c797b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb368201d62e14074803090f81f491571eef67d54e2b338fbc1bd6c8d4c043bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "affd5985894151f44c10a6bcfd7f9abc4cabe11bcbb23009780481e3076787d0"
    sha256 cellar: :any,                 x86_64_linux:  "596702734b88885373e3ac89dc86e8d6c1744ad443e826a3228c95fac6149172"
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