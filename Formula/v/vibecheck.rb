class Vibecheck < Formula
  desc "AI-powered git commit assistant written in Go"
  homepage "https://github.com/rshdhere/vibecheck"
  url "https://ghfast.top/https://github.com/rshdhere/vibecheck/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "1de99d1535f153288897e22ba65710057eac18057f10387a768122a82c6fe0da"
  license "MIT"
  head "https://github.com/rshdhere/vibecheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7e140c57e1181a7838c68470584ed038fb98d9e7368df6eac0a5283afb88abb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7e140c57e1181a7838c68470584ed038fb98d9e7368df6eac0a5283afb88abb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7e140c57e1181a7838c68470584ed038fb98d9e7368df6eac0a5283afb88abb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6b6639cdb9615a4daa0b591e0325d98ccac5d189dd7745693a9e98e9401c703"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7a05b28c5817d7aec8a94e37c18777a60c5a6f1e33d715e5ee167094a2f0549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73a44a0e3f6cfdebae5c4b46d9472c47fdf54982c49a95657aa3a18b7116a0de"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/rshdhere/vibecheck/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vibecheck", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vibecheck --version")
    assert_match "vibecheck self-test OK", shell_output("#{bin}/vibecheck doctor")
  end
end