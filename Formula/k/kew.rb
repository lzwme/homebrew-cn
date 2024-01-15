class Kew < Formula
  desc "Command-line music player"
  homepage "https:github.comravacholkew"
  url "https:github.comravacholkewarchiverefstagsv2.0.3.tar.gz"
  sha256 "80db8326de20cfdb89911b7ac29ccc15604c9aa72a0d711f253c62ef51df181e"
  license "GPL-2.0-only"
  head "https:github.comravacholkew.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dc72ec82ca2a8fdd5623e88d6434d6e449920f346c7aab5b2c34223efde15ea0"
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

    man1.install "docskew.1"
  end

  test do
    (testpath".configkewrc").write ""
    system bin"kew", "path", testpath

    output = shell_output("#{bin}kew song")
    assert_match "Music not found", output

    assert_match version.to_s, shell_output("#{bin}kew --version")
  end
end