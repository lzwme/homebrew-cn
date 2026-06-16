class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.19.13.tar.gz"
  sha256 "0d09261e5f0e75d7cec13632c0c221eabec13eb1000aa7a30f8113b95f3e2b65"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "766c68615376585eefd10044ab6f3ffa4629c8eebb05b5ed9303dc3dbac4c663"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "766c68615376585eefd10044ab6f3ffa4629c8eebb05b5ed9303dc3dbac4c663"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "766c68615376585eefd10044ab6f3ffa4629c8eebb05b5ed9303dc3dbac4c663"
    sha256 cellar: :any_skip_relocation, sonoma:        "63696db74755837664d86e2ef107591a821100d6a6c500639d21540513f4d68f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c3873f1bcda03ad57ef15a688e86c189ada2ffbd09fb93f70cdffd5bdb2c1e6"
    sha256 cellar: :any,                 x86_64_linux:  "13e631b22624002d6ccf1351d777c7f2ceb00d8faba93f7ab6af9607f1ae6697"
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