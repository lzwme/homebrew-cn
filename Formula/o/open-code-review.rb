class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://open-codereview.ai"
  url "https://ghfast.top/https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "24813c739e94985e0468a424a2e3d25c16b0caa4060be0d47f6d7a2a82fc090c"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1a28038a659007f4923b057dde6c14a34fc5193c4b2ce07e97ab60d95803b29b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a28038a659007f4923b057dde6c14a34fc5193c4b2ce07e97ab60d95803b29b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a28038a659007f4923b057dde6c14a34fc5193c4b2ce07e97ab60d95803b29b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fdefca1a379159703e7992be9a59da1af9a9806d0e2711e52d342b54edd935d7"
    sha256 cellar: :any,                 x86_64_linux:      "3e95492307f7a32854ee7c702833665a5657480603d259ba3d2339a463cd4ae7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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