class Tele < Formula
  desc "Keyboard-first Telegram client for the terminal, written in Go"
  homepage "https://github.com/sorokin-vladimir/tele"
  url "https://ghfast.top/https://github.com/sorokin-vladimir/tele/archive/refs/tags/v1.11.12.tar.gz"
  sha256 "80b418c22e6f34edcc16b22eb8a8b14b25b81c0dd2ddc00aa708d4bd32510aa1"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "649e578c33b18d5d47155c845f60d426f031491083d341ddc87c145cd85015ae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d51ad17647834920e70a5c30b39ed27ce575d839c120c74e9298c67b7bd8bc62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "daa6d098003b1c0406cd94ae0dfd18431c683c22982053ed44a0ba1df27fcd8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "473e26079a2a82bfd449db8ba88171feeef461c8549efe7386e3c300e1e4fd92"
    sha256 cellar: :any,                 x86_64_linux:      "491e8df16a30b9a33cb8423673b09832b6f9e6291848fd2c5d765f414a0df369"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/sorokin-vladimir/tele/internal/version.Version=#{version}"), "./cmd/tele"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tele -version")
    assert_match "dumped from tele-dark", shell_output("#{bin}/tele -theme-dump tele-dark")
  end
end