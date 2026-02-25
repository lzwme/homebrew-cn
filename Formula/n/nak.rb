class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.18.5.tar.gz"
  sha256 "ff080c7690cde655408b61e0557300c28d99af02a8c46a973bbccf2f9d61821a"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5272f062777dc1997598ced3b0f9c75a1de9cd75acc17c1b0ee8bd8b654f1c50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5272f062777dc1997598ced3b0f9c75a1de9cd75acc17c1b0ee8bd8b654f1c50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5272f062777dc1997598ced3b0f9c75a1de9cd75acc17c1b0ee8bd8b654f1c50"
    sha256 cellar: :any_skip_relocation, sonoma:        "f519cbfaaf654722ec8d3f6dcb1c209322a6040d884b10ddaac42296c2ef3654"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c19709d6e9113f83efd7e516bd2715bb17d9eaa69106ba144d4d8b8ba8f7c8aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6625b8f96c6aff6af9817c002d8cea9e1836876eb5807643ccf4bae3803badb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  def shell_output_with_tty(cmd)
    return shell_output(cmd) if $stdout.tty?

    require "pty"
    output = []
    PTY.spawn(cmd) do |r, _w, pid|
      r.each { |line| output << line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.wait(pid)
    end

    assert_equal 0, $CHILD_STATUS.exitstatus
    output.join("\n")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nak --version")

    assert_match "hello from the nostr army knife", shell_output_with_tty("#{bin}/nak event")
    assert_match "failed to fetch 'listblockedips'", shell_output_with_tty("#{bin}/nak relay listblockedips 2>&1")
  end
end