class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://ghproxy.com/https://github.com/pixop/video-compare/archive/refs/tags/20231119.tar.gz"
  sha256 "2c6922b7f6418ea4df596664581bde453613ba665f627732cba26d5ff977b5dd"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "48c4ada44c63f4bd6d30113cd42098154fdb1ef2fd2e1034daf495d6cc469c9a"
    sha256 cellar: :any,                 arm64_ventura:  "30aa2221a3a2a4af47fac43eb3f08cae68d985e4d271357488a533f2899a1c9f"
    sha256 cellar: :any,                 arm64_monterey: "bd8f1939a6dfa88a724bf9d3f770521a96fa5aab9a33b93c311d34842c530fe2"
    sha256 cellar: :any,                 sonoma:         "f3eb6bf6da1db0adf3f67e25e2e1d930a7e3e9900dab18bb37da1e62538bdf3d"
    sha256 cellar: :any,                 ventura:        "b765c49cdca5610ce7c2d3f4edab15fc962f4a22726497d289828bcd77bbab97"
    sha256 cellar: :any,                 monterey:       "d75d8b74c740694e4c03bd2ccaa9d3514e17f1f51c5cbb60303b1e3c2287668e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c66cfc05618be0ad59ace167e9d24621ebbd932c3923da1c1a84651cf90b2380"
  end

  depends_on "ffmpeg"
  depends_on "sdl2"
  depends_on "sdl2_ttf"

  def install
    system "make"
    bin.install "video-compare"
  end

  test do
    testvideo = test_fixtures("test.gif") # GIF is valid ffmpeg input format
    begin
      pid = fork do
        exec "#{bin}/video-compare", testvideo, testvideo
      end
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end