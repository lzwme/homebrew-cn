class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghproxy.com/https://github.com/ravachol/kew/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "e660c1ef7a4e39bbb969f431aea6d0406ac574e8dde0d18fca20ec89108809ac"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "72b720c322c906102489c10486bd9e62acb7edb3238fc4007272468eaecf2cc1"
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