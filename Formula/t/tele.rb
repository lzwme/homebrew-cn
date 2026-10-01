class Tele < Formula
  desc "Keyboard-first Telegram client for the terminal, written in Go"
  homepage "https://github.com/sorokin-vladimir/tele"
  url "https://ghfast.top/https://github.com/sorokin-vladimir/tele/archive/refs/tags/v1.11.9.tar.gz"
  sha256 "f2d3cbb3d74f981b41ad38cffca1050bee48cc0aa0cdb36315c33c1308c64753"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "35155f067c6555098d8aad5429cf1a2055bd3bbb41386ccac3ca720a303560aa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1991a4ba02da88bb109c7ec749893ebc1127e780924c3b1d92297f00d982e62b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a82cb98820bb0e525a6fc4efc03e33b1b57080bf29ecdb41bc84a60d3531608"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "19e065a9fad079d7a7c9287e29bc7c0b6c18de921e8ff7e18e528a4fb8730dd9"
    sha256 cellar: :any,                 x86_64_linux:      "00a9e0b55a3d61a757a2dce6208f85ffaa8b7ba24a8568d35c5d26719da17339"
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