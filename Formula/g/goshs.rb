class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https:goshs.deenindex.html"
  url "https:github.compatrickhenergoshsarchiverefstagsv1.0.8.tar.gz"
  sha256 "ee755ea7355eb6264e097c80c04d8a7affb091b4c732b102c685e762374f2f68"
  license "MIT"
  head "https:github.compatrickhenergoshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2aa7632d01f991f5155d1a8cace4020bffcef199adc9c768d59c4074d4359d9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2aa7632d01f991f5155d1a8cace4020bffcef199adc9c768d59c4074d4359d9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2aa7632d01f991f5155d1a8cace4020bffcef199adc9c768d59c4074d4359d9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c5a9a91e9529df0afd5df46aacf4ebd7dc408cef63f0b94d48cd1604a397108"
    sha256 cellar: :any_skip_relocation, ventura:       "7c5a9a91e9529df0afd5df46aacf4ebd7dc408cef63f0b94d48cd1604a397108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb22983ed9ad12e9395b1683a49bead9de1ece58facc2fe281944eb9fdd0c610"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}goshs -v")

    (testpath"test.txt").write "Hello, Goshs!"

    port = free_port
    server_pid = spawn bin"goshs", "-p", port.to_s, "-d", testpath, "-si"
    sleep 2
    output = shell_output("curl -s http:localhost:#{port}test.txt")
    assert_match "Hello, Goshs!", output
  ensure
    Process.kill("TERM", server_pid)
    Process.wait(server_pid)
  end
end