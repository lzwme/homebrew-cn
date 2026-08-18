class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.20.5.tar.gz"
  sha256 "3126b612992e49370f27428de832c439f91f42bd317299af802838ec0e60205c"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b14db4dd3f5c9f90670e82eea8e669a1236fad01394ee9b4a48133a6a8d51e2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b14db4dd3f5c9f90670e82eea8e669a1236fad01394ee9b4a48133a6a8d51e2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b14db4dd3f5c9f90670e82eea8e669a1236fad01394ee9b4a48133a6a8d51e2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f359fdab87bd77f38297d3d711287dc43216f9bd19f7023ecf3fc2cd6ab7ecbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d205b46b1b8dc8c04810f40d4d354aef8b778abdbb40888deeb7b607de1bdf0"
    sha256 cellar: :any,                 x86_64_linux:  "f678a4aed58578b719c0613ce40a008c0b96be819a9b9f52ecec57a4bd42543c"
  end

  depends_on "go" => :build

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