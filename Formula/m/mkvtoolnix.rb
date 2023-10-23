class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-79.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-79.0.tar.xz"
  sha256 "f039c27b0dfe4a4d1aa870ad32e20a28a5f254de6121cb12a42328130be3afbc"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "2b23466dca0d2dc5ab152e0ecf95a8ea4c14230f60b8848dd6681d4909b8cb98"
    sha256 cellar: :any, arm64_ventura:  "5a9d45430e055db161970b34f11d9421ac7e9c3948d98dc2a2b4285c4819b80d"
    sha256 cellar: :any, arm64_monterey: "c98ec29de7c0083938d00f1fc1220de8e71a909c26356e2a3453ca5cbbcf216f"
    sha256 cellar: :any, sonoma:         "252ff7cdea1874e6f7e975c5405be8449216e3413bedc0101b7c7e0b16c36e25"
    sha256 cellar: :any, ventura:        "6866a1ced128e20e2cbc91da9d64911f5a3259857005d7abf3299a078746df4f"
    sha256 cellar: :any, monterey:       "dd0982bb0d6adf04c413ecf7e59543475fe66c55552797e16a7ad157004ef409"
    sha256               x86_64_linux:   "2f7c7ff0ccd1d5ac12e3c6f6f0576345b65fa479fa52b751904d8370bab2a7ef"
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