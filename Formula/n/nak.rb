class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "4b4b54934646716c56ba91dc9141a14bbcb1cc18174b9d4aecf6f92a2764b71c"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9c0ead931f445aabdaddb6d6e87188ec6d48122ef6c455406390444c0644512"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9c0ead931f445aabdaddb6d6e87188ec6d48122ef6c455406390444c0644512"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9c0ead931f445aabdaddb6d6e87188ec6d48122ef6c455406390444c0644512"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e4408b6f940c355dfcf6ddc8b4d13c298a964ed60213572c3d4198e5ccd8c6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cffc076930050a739eef5b6c0c7b96ce46e09fb9af303070b51c2b13336e76f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e1a2e82a461c5390b69ff97af0188ce9853541878673d9ec6f86ac28d5241fd"
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