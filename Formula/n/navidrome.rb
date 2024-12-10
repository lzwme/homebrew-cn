class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with SubsonicAirsonic"
  homepage "https:www.navidrome.org"
  url "https:github.comnavidromenavidromearchiverefstagsv0.53.3.tar.gz"
  sha256 "e0d5b0280c302938177b2241a5f9868a4b40cd603ddf5acb2ff0f9c40e44c13a"
  license "GPL-3.0-only"
  head "https:github.comnavidromenavidrome.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "257ab85c8b8644bcd0c3efacf5f9baaab6b03bd340ac2fb054b617d493e7af10"
    sha256 cellar: :any,                 arm64_sonoma:  "bd075df7bf8f6646a0845c593d3c848880b010c326ac471a511b3a71e622db37"
    sha256 cellar: :any,                 arm64_ventura: "5502c591958cd682ed5641a77ff12c2f705551b09e02eafa4ccee21fe291f17b"
    sha256 cellar: :any,                 sonoma:        "b04fb011646ab0dc5e9f830e2f1cae9bfff0e17e8d55783ac3f89bcda586c0d9"
    sha256 cellar: :any,                 ventura:       "528486a0908d40a33c92c42882b8008301c647ff20df809ddc7f353f24d907c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0b621aae535c95904be115de7e3b8c640c9b1b01906295b54ab917bf5a5b3f5"
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
    system "go", "build", *std_go_args(ldflags:), "-buildvcs=false"
  end

  test do
    assert_equal "#{version} (source_archive)", shell_output("#{bin}navidrome --version").chomp
    port = free_port
    pid = spawn bin"navidrome", "--port", port.to_s
    sleep_count = (OS.mac? && Hardware::CPU.intel?) ? 105 : 30
    sleep sleep_count
    assert_equal ".", shell_output("curl http:localhost:#{port}ping")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end