class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  license "GPL-2.0-or-later"
  revision 2

  stable do
    url "https://mkvtoolnix.download/sources/mkvtoolnix-86.0.tar.xz"
    mirror "https://fossies.org/linux/misc/mkvtoolnix-86.0.tar.xz"
    sha256 "29a9155fbba99f9074de2abcfbdc4e966ea38c16d9f6f547cf2d8d9a48152c97"

    # Compatibility with fmt 11. Remove in next release.
    patch do
      url "https://gitlab.com/mbunkus/mkvtoolnix/-/commit/b57dde69dc80b151844e0762a2ae6bca3ba86d95.diff"
      sha256 "602e0d5fce2ef082f4aecc715352cecb632f99493b8132575ad4c8fc9239579b"
    end
  end

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "40df2a5775c076cfab6b1f1ae2f3ca8fc9e5eab65b83a9ba7258c74718f56978"
    sha256 cellar: :any, arm64_ventura:  "d59b175055d7b202fad6241afa290ab41e0d3b56e6e059d1de37b6229fd050e1"
    sha256 cellar: :any, arm64_monterey: "720432f783d7b8a947283d5d619932f139ac25b5ac284cdaf53ee356340611a4"
    sha256 cellar: :any, sonoma:         "75adc2f45121b6eef16b9a30b2d001a149251f533798ae7a40ed50a1691ff77e"
    sha256 cellar: :any, ventura:        "f38321865993e6c1f9738558f926f31f438a01da7030ac027ab2fe9ac0221d2c"
    sha256 cellar: :any, monterey:       "632e3838f7847f9195f0330707698f3247e16588c17d563eb0069b1d1e23671e"
    sha256               x86_64_linux:   "21d2ed6afb62cb9bfae54e58c0eaa4ee3755a181dbe09ee8022ab686931e7dbd"
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
  uses_from_macos "zlib"

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

    system bin/"mkvmerge", "-o", mkv_path, sub_path
    system bin/"mkvinfo", mkv_path
    system bin/"mkvextract", "tracks", mkv_path, "0:#{sub_path}"
  end
end