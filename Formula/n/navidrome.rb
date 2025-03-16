class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with SubsonicAirsonic"
  homepage "https:www.navidrome.org"
  url "https:github.comnavidromenavidromearchiverefstagsv0.55.1.tar.gz"
  sha256 "721d4509c620aa9094118260a348ea7e58d2a3e9de06a82390c5f0d88b01659e"
  license "GPL-3.0-only"
  head "https:github.comnavidromenavidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "694d266cc47644590e6c95d34f56f5f29d6e9cab85f9bdcfd5b3e1a7ce556969"
    sha256 cellar: :any,                 arm64_sonoma:  "45b365c86f37006438afb6568a7ec4ea17899058fd0c23ed993aca5566e1fc45"
    sha256 cellar: :any,                 arm64_ventura: "3026ab76ef888bc4e756f09aec52b2f64a34c99b2081870d41ec4267aa17d82d"
    sha256 cellar: :any,                 sonoma:        "ee588f631e4c3014d0893ef1bcec1aa3ada992a14ac69f939288d3df2a5ee409"
    sha256 cellar: :any,                 ventura:       "c8c7fb98ceb5ea3a100e359cf0e064d620f6a1eda6f70761866ff5d471c37c32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "942fc2c810b7ebece4f3f34da41a939e3b90e72e55de19e56965f4f7cf1bcc17"
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
    sleep 100 if OS.mac? && Hardware::CPU.intel?
    assert_equal ".", shell_output("curl http:localhost:#{port}ping")
  ensure
    Process.kill "KILL", pid
    Process.wait pid
  end
end