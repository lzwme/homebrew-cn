class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-80.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-80.0.tar.xz"
  sha256 "bb08cdaf9afd472738b9655ae5704c3749da0a51a188baab12f5d7c3eb4d33f5"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "1a0b0a257ac5dcef8b2746931559ffc41b87cd744fc3f6bc915f3778c0637da9"
    sha256 cellar: :any, arm64_ventura:  "5b5abeceb7b95c2ea9203ffa4d634a4d9520ffed9a807cb370be9b2613c0a106"
    sha256 cellar: :any, arm64_monterey: "e147d59f0438071cc72f661a6c4a80ded65c1ed8565c77fca1f5062a35185fd1"
    sha256 cellar: :any, sonoma:         "7746f43ccc45c5a7ead37dcbcfd428e931f1ca7d1e604fa720f342759e920249"
    sha256 cellar: :any, ventura:        "bdbad5693420983ab7becc342bcfe0b5eea55ecc670c8e176b0e1eb2c388fcf0"
    sha256 cellar: :any, monterey:       "c5823ab54513231bc94238585a23d12f664187d447b299bc90c34dfe9bdfb556"
    sha256               x86_64_linux:   "0fc28cb740e548a0d9e3ec71c8070e8d3ea603be0c11827906ba18f492f76c3e"
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