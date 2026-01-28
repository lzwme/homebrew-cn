class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "98c0c608142c05302eea9b894f1bb1457842bfd4896868c9381cae881e152843"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83d8266db96974a9fb68bb11ec32cc5d12cf3487cc37d43e2c2956a6542cc670"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83d8266db96974a9fb68bb11ec32cc5d12cf3487cc37d43e2c2956a6542cc670"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83d8266db96974a9fb68bb11ec32cc5d12cf3487cc37d43e2c2956a6542cc670"
    sha256 cellar: :any_skip_relocation, sonoma:        "67c1ecd821ae7e02482ee65cb673771ce4f5ea16345d230d7dfa062f46682e87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d00868b1ab245f562bd40d1a0ad8f71e2101f2f3ab0df26a4694aa7f3a2ac6f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4864586fd39098cbcdc1f03a4e2ca6eaa5d56ae54a41390b79b38890c25c61a"
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