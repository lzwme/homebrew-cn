class Kew < Formula
  desc "Command-line music player"
  homepage "https:github.comravacholkew"
  url "https:github.comravacholkewarchiverefstagsv2.0.2.tar.gz"
  sha256 "15e29d497b78b2488ebbb31ed5d96f640a4ed85160381219d23249c85aae83db"
  license "GPL-2.0-only"
  head "https:github.comravacholkew.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5b2b420eb86127b44077ee305098c3b180023c98118ce015393aa5d30eb2c91a"
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