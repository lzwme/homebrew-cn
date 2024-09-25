class Archivemount < Formula
  desc "File system for accessing archives using libarchive"
  homepage "https:github.comcybernoidarchivemount"
  url "https:slackware.uk~urchlaysrcarchivemount-0.9.1.tar.gz"
  sha256 "c529b981cacb19541b48ddafdafb2ede47a40fcaf16c677c1e2cd198b159c5b3"
  license "LGPL-2.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, x86_64_linux: "238d9539e81cdafd6d74dee82438d06c4348b5570260102811a2a1362088527c"
  end

  depends_on "pkg-config" => :build
  depends_on "libarchive"
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    ENV.append_to_cflags "-Iusrlocalincludeosxfuse"
    system ".configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system bin"archivemount", "--version"
  end
end