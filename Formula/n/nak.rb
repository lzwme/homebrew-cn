class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "3539229f2f86c37447ec14cf363d95b2d979995e4d82e64aaa3489c570cd296e"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c0a8490424d7cfb4d704488255164a7188919b5ea3bf131ca0c2d8af8a181df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c0a8490424d7cfb4d704488255164a7188919b5ea3bf131ca0c2d8af8a181df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c0a8490424d7cfb4d704488255164a7188919b5ea3bf131ca0c2d8af8a181df"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce30eb9e5b4d088c9efb8bd8b966d6d241ce9b7dd25da2d5238039b6c3f4936b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2c7199ae2e4284bc3211ed994c85a5ef59977b357681ae6020a0cdfa1f6c8d6"
    sha256 cellar: :any,                 x86_64_linux:  "a1ebb206ff3668e3668a648c6decb6ab3357fa4b16de174499daf44cc1a33d60"
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