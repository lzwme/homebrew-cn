class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "daec4f3f11d604899826852ecbf80c081af4208f67a90133bdcb9141608445f6"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8fd0d2d6d8e94f13ca15bf0c9c1814c761ab1bb10c6fc5dfe25c9232d4289104"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8fd0d2d6d8e94f13ca15bf0c9c1814c761ab1bb10c6fc5dfe25c9232d4289104"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8fd0d2d6d8e94f13ca15bf0c9c1814c761ab1bb10c6fc5dfe25c9232d4289104"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6a89b443cb907bd59d508fc694d8eb95e3074512f33c2d085568e3df2261520c"
    sha256 cellar: :any,                 x86_64_linux:      "c5412cacadbda6ee4b9bc20c03f7595392fa53778b17c1bfa6ddcfadc2512666"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  def shell_output_with_tty(cmd, expected_status = 0)
    return shell_output(cmd, expected_status) if $stdout.tty?

    require "pty"
    output = []
    PTY.spawn(cmd) do |r, _w, pid|
      r.each { |line| output << line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.wait(pid)
    end

    assert_equal expected_status, $CHILD_STATUS.exitstatus
    output.join("\n")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nak --version")

    assert_match "hello from the nostr army knife", shell_output_with_tty("#{bin}/nak event")
    relay_output = shell_output_with_tty("#{bin}/nak relay listblockedips 2>&1", 123)
    assert_match "failed to fetch 'listblockedips'", relay_output
  end
end