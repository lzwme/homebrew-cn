class Kew < Formula
  desc "Command-line music player"
  homepage "https:github.comravacholkew"
  url "https:github.comravacholkewarchiverefstagsv2.0.4.tar.gz"
  sha256 "043d6251f4e1cc6c955afad2eda3458f8ea71e75d6ad507e9b99bd153f95ba84"
  license "GPL-2.0-only"
  head "https:github.comravacholkew.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a11b597a4209476983cc3ebde5f86bcf9df6d62e85679291aacb1d73b993365b"
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