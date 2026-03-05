class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.18.7.tar.gz"
  sha256 "a966003788bc22299dac3f76e0c40897eef2c2fa63880bfa5d4d8ef2acaf139b"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0daf94fe8061373e82e5a724afd47547741fdee0725c4b386d31f310d820837b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0daf94fe8061373e82e5a724afd47547741fdee0725c4b386d31f310d820837b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0daf94fe8061373e82e5a724afd47547741fdee0725c4b386d31f310d820837b"
    sha256 cellar: :any_skip_relocation, sonoma:        "abc80600b2da683c27359268baf0944d1c8902d0c95e39f884e7ba7c033b8808"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc9528694283c5ff79f5be6f94afddca5074cca33301c4e0d1e4dab07bcf62df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40a357854959f4528a58339fe778ded36f3037955f9152560a51cd8cb3e1aae8"
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