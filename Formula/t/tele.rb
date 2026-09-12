class Tele < Formula
  desc "Keyboard-first Telegram client for the terminal, written in Go"
  homepage "https://github.com/sorokin-vladimir/tele"
  url "https://ghfast.top/https://github.com/sorokin-vladimir/tele/archive/refs/tags/v1.11.5.tar.gz"
  sha256 "ae563d99ede6e13938776021e22da5ee1a2e557bbfcccf9dc2b9d5e9a377137b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bd52fe29dd2ee4e91c612c61161cdc3ab3b1294371a12e1400afae2d74f16127"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "23c2d762f39c16bca555c1c116a2f01a4d98e048a6d8e25a4a985eea0869c6c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "78d506699b15ea713504dd828c910fdaa1c6dcb64bab7f544e58229a764776c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "88e09d7ac9fb3cfb9ebaf7d696e047f3b00240d28ee7e076b82028dbe69141fe"
    sha256 cellar: :any,                 x86_64_linux:      "615cb216b9e489f7f21e478bde1a2601b03d1ca5fa367201129250ab2134858b"
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