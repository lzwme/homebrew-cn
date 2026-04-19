class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.19.6.tar.gz"
  sha256 "47984d0500183ffc80ee263904046cf4712e506a0ce488ae8a9c8473e023a760"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "754a0682e8df210fc28583e26f5b9e418e81f77282cded5174efc61ceafa27f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "754a0682e8df210fc28583e26f5b9e418e81f77282cded5174efc61ceafa27f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "754a0682e8df210fc28583e26f5b9e418e81f77282cded5174efc61ceafa27f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ce81c1ee48f6c4999a5fc8e33dd12ceea999df105999b74e4ad156d94a6260c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1301f86c2b9beff15d7a5fa2b8057b3047f437d0569420499e7354e1cc6f15cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd7318d5331721b21d2dfccb5bdfc4cc3b7c82b87318bbfcb1a32196f6ca74f4"
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