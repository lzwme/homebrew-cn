class Kew < Formula
  desc "Command-line music player"
  homepage "https:github.comravacholkew"
  url "https:github.comravacholkewarchiverefstagsv2.8.tar.gz"
  sha256 "5619e09df2e217f15e959f02bd49e5db3d539deb3e1858bf153f1ceaca60941c"
  license "GPL-2.0-only"
  head "https:github.comravacholkew.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4319ecde7e84b72d873dc0635c08af45ae9eb66f82333c66ecfa010ed36a788b"
  end

  depends_on "pkg-config" => :build
  depends_on "chafa"
  depends_on "ffmpeg"
  depends_on "fftw"
  depends_on "freeimage"
  depends_on "glib"
  depends_on "libnotify"
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
    assert_match "No Music found.\nPlease make sure the path is set correctly", output

    assert_match version.to_s, shell_output("#{bin}kew --version")
  end
end