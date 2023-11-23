class Libmp3splt < Formula
  desc "Utility library to split mp3, ogg, and FLAC files"
  homepage "https://mp3splt.sourceforge.net/mp3splt_page/home.php"
  url "https://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.9.2/libmp3splt-0.9.2.tar.gz"
  sha256 "30eed64fce58cb379b7cc6a0d8e545579cb99d0f0f31eb00b9acc8aaa1b035dc"
  license "GPL-2.0-only"
  revision 5

  # We check the "libmp3splt" directory page since versions aren't present in
  # the RSS feed as of writing.
  livecheck do
    url "https://sourceforge.net/projects/mp3splt/files/libmp3splt/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+[a-z]?)/?["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 arm64_sonoma:   "2f380b2eacaeb05e2e64086dfde7da692549b30a6b41a70863d6d236514c6845"
    sha256 arm64_ventura:  "4f73132687de63d8e7f0c31d8e6d99c54889fef07e678d99ab5afbfe0fd4f671"
    sha256 arm64_monterey: "07a86cbc39231dcf025a2972b7b0f748cc9bc4ee2c63a7b44345f9a09d265b44"
    sha256 sonoma:         "943ef08c662ae9db6b4ef36844e547c47393eedcc37b644134b37234b6b51df9"
    sha256 ventura:        "87a77d0aa17c5a05a3d62ab8466067a8bb96c0a3938b470911bbaa044a823a40"
    sha256 monterey:       "5a2d68899193ae71ab3a1a3d1455bf6266b0697597eee1ab27b1d7336b75df82"
    sha256 x86_64_linux:   "f66285e611fcf8e00ecc25b5d3fd4a88717e9d48fc8048fedca60f874fe73200"
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "gettext"
  depends_on "libid3tag"
  depends_on "libogg"
  depends_on "libtool"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "pcre"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end