class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "6c486c77e8808f93b5b87a8080ad48ec3c51cf76ced8a8a4d5b6efedcc7186a4"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7668cc62d9a202f81e589a1891968bf28e633c9c9bbe17cdd9612118fe549d3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7668cc62d9a202f81e589a1891968bf28e633c9c9bbe17cdd9612118fe549d3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7668cc62d9a202f81e589a1891968bf28e633c9c9bbe17cdd9612118fe549d3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd77f180ca87de80fbcf50776b71875ca2bacd60f9cf560ec9ddc10c86c80a73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbadd1b0bb79c2a927bb06d5faa99117922d6ffd405b6225113babc15a35bacf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "036996c39ab3b4e2b29b099e97064842ceca057f1b50a36a9be2d4ee047f23cf"
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