class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://ghfast.top/https://github.com/navidrome/navidrome/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "34b813c5ded6fcf9ec101e28a81cfb6c71da5e8aeba67aa6a7effbcdd9fb4a7e"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34e2921955c057c57c25b7ae6f4c1d65612cac73a26ad70f416ec3638e65477c"
    sha256 cellar: :any,                 arm64_sequoia: "364203ca5a00668ae312fbcac8127870bb2d9c39ea2cf61bbfcc25f8acff203e"
    sha256 cellar: :any,                 arm64_sonoma:  "812cd9375ef020d7b5251e25d26a165d519e323afeccd92378366a5562995c34"
    sha256 cellar: :any,                 sonoma:        "09d1cc22b76f20d2de8d202cb3696c4e871e412e7edb2b27a7c58a2a8d9ab31d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be0dc28ee1f02de014ca39c19cffd5f259ca1665bb19b5153e706b742a5a1c4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbe71cd9638d57632af1a1bb7097aef7f61535d24b71295d69775beeef031bc4"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "taglib"

  def install
    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -s -w
      -X github.com/navidrome/navidrome/consts.gitTag=v#{version}
      -X github.com/navidrome/navidrome/consts.gitSha=source_archive
    ]

    system "make", "setup"
    system "make", "buildjs"
    system "go", "build", *std_go_args(ldflags:, tags: "netgo"), "-buildvcs=false"
  end

  test do
    assert_equal "#{version} (source_archive)", shell_output("#{bin}/navidrome --version").chomp
    port = free_port
    pid = spawn bin/"navidrome", "--port", port.to_s
    sleep 20
    sleep 100 if OS.mac? && Hardware::CPU.intel?
    assert_equal ".", shell_output("curl http://localhost:#{port}/ping")
  ensure
    Process.kill "KILL", pid
    Process.wait pid
  end
end