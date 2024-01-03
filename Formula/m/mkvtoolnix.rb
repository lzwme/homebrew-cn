class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-82.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-82.0.tar.xz"
  sha256 "635f1dcdc6c42852ea8fe621b50f68c224dda970fd8086944685111368d9c50c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "745a6957893983bc97810afeb2e0968c0bc36247c4454797ed226ba3ba2fc688"
    sha256 cellar: :any, arm64_ventura:  "fb523e1c6dfe4009cfbfd17466ecc4b22095f195e9abc832546695305a535cd2"
    sha256 cellar: :any, arm64_monterey: "8d940c9bd812ef5ba38284d82819868cf54cc6d62e5f5da8546d28bb588c622c"
    sha256 cellar: :any, sonoma:         "6e527c7afe6264ba7334732ebe09e9538d4f491f19f635f9004ec82758106ea0"
    sha256 cellar: :any, ventura:        "06580e9dba18622a8ccc2a2b5a5e249a8ff15a91c9570561b59efbc41462bc21"
    sha256 cellar: :any, monterey:       "36a886f2143ff41a1a8aaecbb88e98822458d53a91744adfec3742b143cb5da1"
    sha256               x86_64_linux:   "ca4c484a164b45deb963c19433ccb662d509ceb36d4c901a106f3040e22bb568"
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