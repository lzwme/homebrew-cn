class Tele < Formula
  desc "Keyboard-first Telegram client for the terminal, written in Go"
  homepage "https://github.com/sorokin-vladimir/tele"
  url "https://ghfast.top/https://github.com/sorokin-vladimir/tele/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "8cdabdede276fec956316745e7bd57d9d0977534d5663948bafd869f052242d8"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "478cf236eaf49a0ffc023da3c63afcfe84921940fcff33ba2ea7f92aef4ae386"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f31b0095f154292630d0ff7be7755b710798b601c02f4c862effa68e19ea8b1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e91fa84793fc38fcf7db83bc8ecdaec5dcc98e5782cdad4f1db36670ed7b2fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9924f04614f04c970960a9f5bf06774ab97e6c0e44fb8c74f7fa08999682c256"
    sha256 cellar: :any,                 x86_64_linux:  "eb501bfd8ad8f234353849a108fe50abae8800c28507ea4ff60e6b5bc1a2cfa9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/sorokin-vladimir/tele/internal/version.Version=#{version}"), "./cmd/tele"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tele -version")
    assert_match "dumped from tele-dark", shell_output("#{bin}/tele -theme-dump tele-dark")
  end
end