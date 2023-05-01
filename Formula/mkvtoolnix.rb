class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-76.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-76.0.tar.xz"
  sha256 "6ace661b61a49d1026b1a97336051d7aa85d56fb34527f2ca97d8933f7efe90d"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "ba2d5b7a349502f99c170fb56ee60906dfaf9b4e5a4d4ba96671df84eec5f30b"
    sha256 cellar: :any, arm64_monterey: "0247af3b1c654b3b8798f1ba4aa0a2873d5d30afebb1f9d5c74a6e67fea5f5da"
    sha256 cellar: :any, arm64_big_sur:  "b92df2b55ce9e3b3e60db47a2aeeab3519c2edee87a4d175086ad08044ec4630"
    sha256 cellar: :any, ventura:        "b564a1abc777747f60b1882345237105823f33ff6430749f0a3e63e5d896852b"
    sha256 cellar: :any, monterey:       "fdbf751f41cfc14576125dc59f37163e9b06db31a385de345e0a781c1e4a5ae1"
    sha256 cellar: :any, big_sur:        "e6413bd01996743de76314e63e4e9a816175891b9dae372ed5af290a93d43d23"
    sha256               x86_64_linux:   "c98ad7a1baccf53625aa153d0e5aa8a9a79eb5c51516ad66a3643f7dfeab06e2"
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