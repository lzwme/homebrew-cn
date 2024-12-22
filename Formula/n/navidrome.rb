class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with SubsonicAirsonic"
  homepage "https:www.navidrome.org"
  url "https:github.comnavidromenavidromearchiverefstagsv0.54.1.tar.gz"
  sha256 "75d2275eab355d7627a0f7c6a0579db14ef52e04f3029b1845ea35f99ab105ae"
  license "GPL-3.0-only"
  head "https:github.comnavidromenavidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8300ee77926f4019cc102efaef2211202cdb13730ec4b7f466155819326b6ffc"
    sha256 cellar: :any,                 arm64_sonoma:  "5aafeddb57e26fd7e6a38f05086c03666deeba1ce5355c4e2f779d2475cbb5e0"
    sha256 cellar: :any,                 arm64_ventura: "abc7b433c2955b63d6e5462432eea0e00d02b2631909bee6e696b1de8e7d2533"
    sha256 cellar: :any,                 sonoma:        "2f7265f468f42b0696ab28827b25bdbb9cb8135fcd2e1f85017ea0c3eb54f592"
    sha256 cellar: :any,                 ventura:       "680367d67e967db95b2c542c12d1484404913a9766e08cba133edbec590390d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af571fcca73be08d597684cd276a01558fc92d9450e75a81fe53620dc409cbd7"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "taglib"

  def install
    ldflags = %W[
      -s -w
      -X github.comnavidromenavidromeconsts.gitTag=v#{version}
      -X github.comnavidromenavidromeconsts.gitSha=source_archive
    ]

    system "make", "setup"
    system "make", "buildjs"
    system "go", "build", *std_go_args(ldflags:), "-buildvcs=false", "-tags=netgo"
  end

  test do
    assert_equal "#{version} (source_archive)", shell_output("#{bin}navidrome --version").chomp
    port = free_port
    pid = spawn bin"navidrome", "--port", port.to_s
    sleep 20
    sleep 60 if OS.mac? && Hardware::CPU.intel?
    assert_equal ".", shell_output("curl http:localhost:#{port}ping")
  ensure
    Process.kill "KILL", pid
    Process.wait pid
  end
end