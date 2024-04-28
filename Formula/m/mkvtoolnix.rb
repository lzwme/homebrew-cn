class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-83.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-83.0.tar.xz"
  sha256 "6a8615436406c7fa45bfb2b6270da1bf06ea54cfcd13c3699643833e1d73ecbc"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "7dce073e486620bf5207b37e1a99b0cdb01ece4be0dd7f4ff1445c0a1a186f8a"
    sha256 cellar: :any, arm64_ventura:  "8b38f99c616e71d434ba0b0396ddf51652e1a9e6b0e78dc9ff34e7bab9e65beb"
    sha256 cellar: :any, arm64_monterey: "25dc92229fe877c8f143e6876d150b76f735343821b05ecaeb72e7d7767fdecc"
    sha256 cellar: :any, sonoma:         "57a51169f464249c4f849008d7f2c28a1ee086c796159e9e9016e7a4cd390947"
    sha256 cellar: :any, ventura:        "94768904ced08a46a0c32f599172e82a2c244034f9454eb98e048c4e56bc5be1"
    sha256 cellar: :any, monterey:       "b853e5149645d4a7355e4aac26efd821cb502e68436910ca8fc2dcaf9157b256"
    sha256               x86_64_linux:   "520c797ccfe00eec3d2bf248e5f981197cb4c523588615e624c04c7271d373fa"
  end

  head do
    url "https://gitlab.com/mbunkus/mkvtoolnix.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "flac"
  depends_on "fmt"
  depends_on "gettext"
  depends_on "gmp"
  depends_on "libebml"
  depends_on "libmatroska"
  depends_on "libogg"
  depends_on "libvorbis"
  # https://mkvtoolnix.download/downloads.html#macosx
  depends_on macos: :catalina # C++17
  depends_on "nlohmann-json"
  depends_on "pugixml"
  depends_on "qt"
  depends_on "utf8cpp"

  uses_from_macos "libxslt" => :build
  uses_from_macos "ruby" => :build

  fails_with gcc: "5"

  def install
    ENV.cxx11

    features = %w[flac gmp libebml libmatroska libogg libvorbis]
    extra_includes = ""
    extra_libs = ""
    features.each do |feature|
      extra_includes << "#{Formula[feature].opt_include};"
      extra_libs << "#{Formula[feature].opt_lib};"
    end
    extra_includes << "#{Formula["utf8cpp"].opt_include}/utf8cpp;"
    extra_includes.chop!
    extra_libs.chop!

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          "--with-docbook-xsl-root=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl",
                          "--with-extra-includes=#{extra_includes}",
                          "--with-extra-libs=#{extra_libs}",
                          "--disable-gui"
    system "rake", "-j#{ENV.make_jobs}"
    system "rake", "install"
  end

  test do
    mkv_path = testpath/"Great.Movie.mkv"
    sub_path = testpath/"subtitles.srt"
    sub_path.write <<~EOS
      1
      00:00:10,500 --> 00:00:13,000
      Homebrew
    EOS

    system "#{bin}/mkvmerge", "-o", mkv_path, sub_path
    system "#{bin}/mkvinfo", mkv_path
    system "#{bin}/mkvextract", "tracks", mkv_path, "0:#{sub_path}"
  end
end