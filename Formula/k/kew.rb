class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghproxy.com/https://github.com/ravachol/kew/archive/refs/tags/1.7.2.tar.gz"
  sha256 "9ad1b2b8a7d55c65dac8303d5c1a58cb5567fde6cb7290ad482cabd60fd12612"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "60ef03bdaafb79edef14a1cef4aec634e74abb743a82d9f0e58e1597794cf555"
  end

  depends_on "pkg-config" => :build
  depends_on "chafa"
  depends_on "ffmpeg"
  depends_on "fftw"
  depends_on "freeimage"
  depends_on "glib"
  depends_on "libvorbis"
  depends_on :linux
  depends_on "opusfile"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    man1.install "docs/kew.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kew --version")

    output = shell_output("#{bin}/kew song")
    assert_match "Music not found", output
  end
end