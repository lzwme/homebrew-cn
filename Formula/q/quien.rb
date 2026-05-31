class Quien < Formula
  desc "Better WHOIS and domain intelligence toolkit"
  homepage "https://benword.com/quien-a-better-whois-and-domain-intelligence-toolkit"
  url "https://ghfast.top/https://github.com/retlehs/quien/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "35bb500f7929ccfc22091a201c35c0e9e660ccd3da383f8b42a4e95530333fbe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d460b3269973669cdb01e7013323efaa191e78977f4756c1b4c213961b261ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d460b3269973669cdb01e7013323efaa191e78977f4756c1b4c213961b261ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d460b3269973669cdb01e7013323efaa191e78977f4756c1b4c213961b261ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "384c69e6a6f3bd6de62f40f6bb9d87bb4522ef1058a4983fedce5e29f6137726"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "108c32294d38248ce3ce4cde2f6327fa2d41c1cdc66b526a438aedd41460d1da"
    sha256 cellar: :any,                 x86_64_linux:  "813de163d1a8b41f55aa4f2aea52422f57a78ba5a38398640f3c5fa51813459f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "expect"
    require "pty"

    PTY.spawn(bin/"quien", "google.com") do |r, w, pid|
      r.expect "Org *Google LLC"
      w.write "s"
      r.expect "Issuer *Google Trust Services"
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end