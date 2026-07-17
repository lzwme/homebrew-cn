class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "e30ae5f776749dfe2312675fff1d057da771451f3d647c6c948b6fca6498656c"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a858ae9e2dd05eb62ee8f9b59fc0e450ff9abd67710d4364a2e6ea89d0740f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a858ae9e2dd05eb62ee8f9b59fc0e450ff9abd67710d4364a2e6ea89d0740f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a858ae9e2dd05eb62ee8f9b59fc0e450ff9abd67710d4364a2e6ea89d0740f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "27b8bad92b6210d8fe7a7194b9ab17b82569447dd77cd2619c8e35d99a147cf8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57d3e0e3d2ac9e76cbfd982549e1523b8bce668776664d2e68546b0be2d9c4b4"
    sha256 cellar: :any,                 x86_64_linux:  "a45fd597bb6155f3799f1249e676a8606be04239eb940ca22c49216491ac9e2c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
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