class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with SubsonicAirsonic"
  homepage "https:www.navidrome.org"
  url "https:github.comnavidromenavidromearchiverefstagsv0.52.5.tar.gz"
  sha256 "9e5a81589d3e0c04d8cd06dccc680942d082f3d02aa4f0fd2b67dedf9902063b"
  license "GPL-3.0-only"
  head "https:github.comnavidromenavidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d6397b234958e6520eaf7224a49aa94f5333896eb65b219cd37753c38a405777"
    sha256 cellar: :any,                 arm64_sonoma:   "37ee945b3c210d57760b8132e470dfb5b7f963c7f551b7f22a3c4ae0385270b7"
    sha256 cellar: :any,                 arm64_ventura:  "a60a48c4203b74f86db04c2de1c982ba4a7fd75e44b55528818f42a3ec947a45"
    sha256 cellar: :any,                 arm64_monterey: "916cf2ac13a877e57539dcc9757f098fb00ad6e755246786ddad87bfc8de3778"
    sha256 cellar: :any,                 sonoma:         "1e4298c375cd4ca19bb17fb488dfbaa3462c694477c46815ed92196fe4317318"
    sha256 cellar: :any,                 ventura:        "052d6a8e2f04eedb8a3b58e627aa9e86491facccfe4c4f0cf491b249a598bbc9"
    sha256 cellar: :any,                 monterey:       "e0648dbf7635f108481fac630e28f02db6ba7d8b86693e1ca42402ed5549c475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2820f2554b02306483c389a70ba96eca444b192bad8ac9d295adc1cb9909eaa"
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