class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.19.12.tar.gz"
  sha256 "2233514e4d26d6c1eb852b0de187fe06e50f0705da8088bf15e8266c5264153c"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f73692e2397612fb8c4ee1ed4ae5f611f821de3770f244902730f8d75b3caacb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f73692e2397612fb8c4ee1ed4ae5f611f821de3770f244902730f8d75b3caacb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f73692e2397612fb8c4ee1ed4ae5f611f821de3770f244902730f8d75b3caacb"
    sha256 cellar: :any_skip_relocation, sonoma:        "3897de5e167d58b000a8549e8820a87547d87cd34813966b88db538329a30910"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce20eff863d081e98eb5320390acf1a4b1486a429467493b84ea1fe0cec2b7eb"
    sha256 cellar: :any,                 x86_64_linux:  "c5363b0b1a292e72bd5d7cbeef6657b99055b8d8bb177f7e8d61686cf4eaf947"
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