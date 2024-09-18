class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with SubsonicAirsonic"
  homepage "https:www.navidrome.org"
  url "https:github.comnavidromenavidromearchiverefstagsv0.53.1.tar.gz"
  sha256 "026be65faa4c7e8c02c8cfff4b1ca37fee531d6fbbb7d81a27cf70500775e1f2"
  license "GPL-3.0-only"
  head "https:github.comnavidromenavidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0134c3c1c7d1d4dab82a751787c3044137dce9ccf0f4d7ea0301a00d9e008f0e"
    sha256 cellar: :any,                 arm64_sonoma:  "c5d94a931d6ecf94226485edc9f8b8466fa04a6d429c8934e3d1b6ba07e91c61"
    sha256 cellar: :any,                 arm64_ventura: "007efe93fc43478f1f114ab5812661a23bffae12670dbef15016ae3179f43dad"
    sha256 cellar: :any,                 sonoma:        "bf0c330081087a0998fcf5db5dae9e5726cfe565fee7ebace6fe3b97844935d2"
    sha256 cellar: :any,                 ventura:       "c57c7b1fdcff60038ab922daa061049b6f212b2e5e0cdea36434d01793952a36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79cf21a5b15ea448c96827a98bd404f755d060e8913690cfb47ef4b565fc23b6"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "taglib"

  def install
    system "make", "setup"
    system "make", "buildjs"
    system "go", "build", *std_go_args(ldflags: "-X github.comnavidromenavidromeconsts.gitTag=v#{version} -X github.comnavidromenavidromeconsts.gitSha=source_archive"), "-buildvcs=false"
  end

  test do
    assert_equal "#{version} (source_archive)", shell_output("#{bin}navidrome --version").chomp
    port = free_port
    pid = fork do
      exec bin"navidrome", "--port", port.to_s
    end
    sleep 15
    assert_equal ".", shell_output("curl http:localhost:#{port}ping")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end