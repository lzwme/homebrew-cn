class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "f66cc4e66c4812ddfbc684771cc5438eeb343c49ea7787087acec160f2b40078"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01fe23f6ffb89915c6e7636fe69ad8b6cf89b2de2c649a6312c644013d9ab2ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01fe23f6ffb89915c6e7636fe69ad8b6cf89b2de2c649a6312c644013d9ab2ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01fe23f6ffb89915c6e7636fe69ad8b6cf89b2de2c649a6312c644013d9ab2ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "50670d8d3afcc6ae41cd87bc69d0fd4df35f8b5040f2a6f490776c5c59f0f587"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b95c295fac0aa3cbf52458bb116bffcf1c81ce8a177151b64a130fb40046bf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64d0185a499e3cdd7a0366a00291fd851fe5c4936f921d3dde3bae2dc00e1b19"
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