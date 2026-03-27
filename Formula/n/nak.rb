class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "6d599061e548630dd717c9e4c76a5578fe021dee57f1ad8e894a814327c77e2d"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b860701263172f0fba27cb5dd0e05a6cd792752bc799bd6a9c2436c7efa0cb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b860701263172f0fba27cb5dd0e05a6cd792752bc799bd6a9c2436c7efa0cb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b860701263172f0fba27cb5dd0e05a6cd792752bc799bd6a9c2436c7efa0cb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e15520821301e048d9a51aa2d18c7b7180646fc4a5bde49b1461b6adce5614b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67ff731d5ea1f8c18d05200f726f995c581cd357d211821bbae5d3ba1837c403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14b6092f9dd65ae24d5706775ae38fbe195cd3a0d4c8d07b839d1728db462780"
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