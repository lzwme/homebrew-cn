class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.8.tar.gz"
  sha256 "a829f329cb39a4ad6c617b7b70e5152597691f38cdf919c842214602e4e81bdc"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc7eac89086051dd51bb148cae61b36be5bc164f49a36759cc11d9466b7c7540"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc7eac89086051dd51bb148cae61b36be5bc164f49a36759cc11d9466b7c7540"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc7eac89086051dd51bb148cae61b36be5bc164f49a36759cc11d9466b7c7540"
    sha256 cellar: :any_skip_relocation, sonoma:        "5adfeec1cebf5bc4967aaba0fa458fba0fe3858b0a954d50b03c033c3c5ecf1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8030f3a08d80e9c70ecd8d9195699403806e5445b75176b4e4d22612f26e71a0"
    sha256 cellar: :any,                 x86_64_linux:  "5a2104dd86e410bcbd6085128e931209037be1ebc0401b09a4f3f19caf71971e"
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