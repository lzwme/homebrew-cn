class Tele < Formula
  desc "Keyboard-first Telegram client for the terminal, written in Go"
  homepage "https://github.com/sorokin-vladimir/tele"
  url "https://ghfast.top/https://github.com/sorokin-vladimir/tele/archive/refs/tags/v1.11.8.tar.gz"
  sha256 "8119dd7aab12a4ea108b4d4a65f85423bc82c7752767b31916b6acea1ece1b53"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f1838ba5250b6689d9522895b119417e4436bc477df58a7027defcf77bffa8d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d6a18bfd00ff2544be4847148d4ff244059ec6bbf35a1a0847364b96c6de2351"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4df49378fef58e7a66be95d8531b81d4c45ea1a77b64c61649355c4660098e4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8800983c197d207d7e13698351b85b0789979e1bac90efc439bee2520bc1a53e"
    sha256 cellar: :any,                 x86_64_linux:      "24b464499af1862b54fad2e4bd1deeb38584b0d0896481cf5e71d3ab7ca2b69f"
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