class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  license "GPL-2.0-or-later"
  revision 1

  stable do
    url "https://mkvtoolnix.download/sources/mkvtoolnix-76.0.tar.xz"
    mirror "https://fossies.org/linux/misc/mkvtoolnix-76.0.tar.xz"
    sha256 "6ace661b61a49d1026b1a97336051d7aa85d56fb34527f2ca97d8933f7efe90d"
    # Add fmt 10 support, the full patch does not apply to stable
    # https://gitlab.com/mbunkus/mkvtoolnix/-/commit/24716ce95bf5b10d685611de23489045cf2ca5cc
    patch :DATA
  end

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "fd58f367280b60bec36628fe54ceb870510bc7af28ded49771e3f8b209f81d0c"
    sha256 cellar: :any, arm64_monterey: "d39aa427fd40def69bc008b98c27fd0b3fcb638e5293a2d5cb9668fbe0820058"
    sha256 cellar: :any, arm64_big_sur:  "52cbc71539350c84160855576c280407a607e878e8f7ead67934d21840008b44"
    sha256 cellar: :any, ventura:        "e20ae02c38440b3dabeb21caf4548c98c25be06dc734e37727e5ed9fab91fe0e"
    sha256 cellar: :any, monterey:       "1eacc3b2fecee2c495568f057ef188b63363790ed7220ca4cc839db3afc794ea"
    sha256 cellar: :any, big_sur:        "dcc822b3b81883d9d9a417e3cabf348e90fe99225a225dbf50f74ebc674be955"
    sha256               x86_64_linux:   "5ae8d64da2228d553506f785c074da8866bfc2dbe274e6572b0ad6ca1b09a940"
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

__END__
diff --git a/src/common/codec.h b/src/common/codec.h
index f8bc1b4e36cb01e3e9096e681e4211e04903410b..f4a92c3223044664c454399423fa7df33f1cbca6 100644
--- a/src/common/codec.h
+++ b/src/common/codec.h
@@ -231,3 +231,7 @@ operator <<(std::ostream &out,
 
   return out;
 }
+
+#if FMT_VERSION >= 90000
+template <> struct fmt::formatter<codec_c> : ostream_formatter {};
+#endif  // FMT_VERSION >= 90000