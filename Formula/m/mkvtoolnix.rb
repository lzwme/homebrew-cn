class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-81.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-81.0.tar.xz"
  sha256 "422f2bec88d5d93547df0c3e1399272a6dc4c23050b45d34343bbdd6d55e5ad6"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "e76a6a63fa22d2889edd4f8e42f83b29b57826c757ce057a6e470b8ecb501164"
    sha256 cellar: :any, arm64_ventura:  "48106f23cccbd2c4280e9a2be016c53df35c6f487483159ded240d4a4fbd0957"
    sha256 cellar: :any, arm64_monterey: "d50ac708d24ab1cef182bb82ddc3fa0ed3db8c336088532b2f5b58cf3bc00040"
    sha256 cellar: :any, sonoma:         "bcadd9a2852e2ab44113e232a49cb5b89bc21d5b36fad115393e159f103a6d4c"
    sha256 cellar: :any, ventura:        "faf2195bf9692e66aa0632fe2695246a1f501b41854f8df0972e5d80eff044b9"
    sha256 cellar: :any, monterey:       "3db7dd1c5a27adefd59e883ab8fa3dfaeca0fee0159bd066fee2c505eaf555f2"
    sha256               x86_64_linux:   "7397fd1a7458bbee47bf26484bc2ed37fccd9b125acea4b1ac91f0ed8e2dd11d"
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