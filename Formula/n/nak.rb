class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.20.4.tar.gz"
  sha256 "353a5d61d0c69a7b075dfb5c7cbb490e9ee50149db9ce1d3dff364b8b5a40932"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eaf4aae317c0ff44b5bc6ce2a4d4ccbdb874de47fc9c5542bb1fa60c5a7f4180"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaf4aae317c0ff44b5bc6ce2a4d4ccbdb874de47fc9c5542bb1fa60c5a7f4180"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eaf4aae317c0ff44b5bc6ce2a4d4ccbdb874de47fc9c5542bb1fa60c5a7f4180"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e14ccd41b3bd48338eff6059e4c22d4daaf03e06d048981b46c0d2f8a1a1ab7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bec132a601aaaf75339c1962004fd3e850f294fcff313f6771ef93c12ca9bf5"
    sha256 cellar: :any,                 x86_64_linux:  "b526f4398556e6efd1b6c0f74b7e641959682350cf316e50f0f282bdcb6d8fcd"
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