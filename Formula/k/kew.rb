class Kew < Formula
  desc "Command-line music player"
  homepage "https:github.comravacholkew"
  url "https:github.comravacholkewarchiverefstagsv2.4.tar.gz"
  sha256 "fb8d579a196442cd7e3d2d7c64541db0ae55ef64302ad0d21748ecc2c7020b74"
  license "GPL-2.0-only"
  head "https:github.comravacholkew.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6c23b67331942c25c4a29bcef6d62634ce46933b5cdb06784138d0487e57d98e"
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