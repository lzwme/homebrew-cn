class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "de4849bc92c718d1ad9a0e414f6e97aae130e00efec5a10b3e2eb04bbfde95fa"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d726f3b7bbfe757d52b1e1b87128d45f73f802c6bb76cabc8aab2875fa27bab7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d726f3b7bbfe757d52b1e1b87128d45f73f802c6bb76cabc8aab2875fa27bab7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d726f3b7bbfe757d52b1e1b87128d45f73f802c6bb76cabc8aab2875fa27bab7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b65ed37cbccc95caef1d0ad3cdae131acf44277a7e405625e272ec3b985abd96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74d430ac4b2294824e5d20633e5725034df74a3d94ab08d67096dba16b0317c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75d72f37357a044f02ec3d16fc44b154e1bad8ba1c7f88b3bc2ec16edd55680b"
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