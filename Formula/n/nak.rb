class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.19.10.tar.gz"
  sha256 "711dfda5b569dce388d110a61da37cf02f3e6dfd8ee0be93d27c36176f96b1cb"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6cdd31a926d05654d7284a594df8d7b2fd7adba3f847b867d7931ed3f2ab7ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6cdd31a926d05654d7284a594df8d7b2fd7adba3f847b867d7931ed3f2ab7ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6cdd31a926d05654d7284a594df8d7b2fd7adba3f847b867d7931ed3f2ab7ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c10ad5a2e5000a04b39889c4f870d3de66924a9d09dc717bcba02ec51cb73ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "305704972aedf3a611de8e8cdebfbdb75b0b926ff368ca2a6245dbfe239baba6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "424e6ea495cf275e73285d1081deb2486ffc6588258676fd4d16d9274605cc11"
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