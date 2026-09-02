class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "88e936766f61e5467d3179000e8eb48a2ec2ff95106179c58b3800af13fc7720"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a68dd02f4ecd03965af859a88d9231138444c7f61c938c8cddcdc67e4a504ae1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a68dd02f4ecd03965af859a88d9231138444c7f61c938c8cddcdc67e4a504ae1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a68dd02f4ecd03965af859a88d9231138444c7f61c938c8cddcdc67e4a504ae1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ee8c6d6f9ebf86ab2d9c1158f9d2071f0bb167387a5ea498d2aca19048ef994"
    sha256 cellar: :any,                 x86_64_linux:  "4ea4202fe2fcbb7699c9acf721edff5f76c298ea05c78d14d8e1c4e3116ed326"
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