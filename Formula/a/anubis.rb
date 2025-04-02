class Anubis < Formula
  desc "Protect resources from scraper bots"
  homepage "https:anubis.techaro.lol"
  url "https:github.comTecharoHQanubisarchiverefstagsv1.15.1.tar.gz"
  sha256 "58e60d4454e5e5312e9df2281a988f0bbf2ccc01263d1ec169131f3ccab3db40"
  license "MIT"
  head "https:github.comTecharoHQanubis.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcdbc2ebbef460affd351877dd9778f0084e3523c698775fa769fbb41235dcdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce6efaec46b7dc85cccc5c7c44a78c483cb2603d7fabae0c0399c33f6dc946e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7456d8dca10efe2b7f5ca6a4b58a38db24024d8b8c818a5f1cdb759fd07fb310"
    sha256 cellar: :any_skip_relocation, sonoma:        "9569b50ebbc1466989b94034d904e9ba5ec6a1ba084a73d2165c013dfe1a551b"
    sha256 cellar: :any_skip_relocation, ventura:       "da031fd5e3d5bfdc3dd7662f1df138f28851254d94672f37f6183ce6aeebe9ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9827290dc34dbff628e6871ac89c6cc192f1e3b1ce00e0e718dbe733de7f1a82"
  end

  depends_on "go" => :build
  depends_on "webify" => :test

  def install
    ldflags = "-s -w -X github.comTecharoHQanubis.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdanubis"
  end

  test do
    webify_port = free_port
    anubis_port = free_port

    webify_pid = spawn Formula["webify"].opt_bin"webify", "-addr", ":#{webify_port}", "echo", "Homebrew"
    anubis_pid = spawn bin"anubis", "-bind", ":#{anubis_port}", "-target", "http:localhost:#{webify_port}",
      "-serve-robots-txt", "-debug-x-real-ip-default", "127.0.0.1"

    assert_includes shell_output("curl --silent --retry 5 --retry-connrefused http:localhost:#{anubis_port}"),
      "Homebrew"

    expected_robots_txt = <<~EOS
      User-agent: *
      Disallow: 
    EOS
    assert_includes shell_output("curl --silent http:localhost:#{anubis_port}robots.txt"),
      expected_robots_txt.strip
  ensure
    Process.kill "TERM", anubis_pid
    Process.kill "TERM", webify_pid
    Process.wait anubis_pid
    Process.wait webify_pid
  end
end