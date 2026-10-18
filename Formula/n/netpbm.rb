class Netpbm < Formula
  desc "Image manipulation"
  homepage "https://netpbm.sourceforge.net/"
  # Maintainers: Look at https://sourceforge.net/p/netpbm/code/HEAD/tree/
  # for stable versions and matching revisions.
  url "https://ghfast.top/https://github.com/jwilk-mirrors/netpbm/archive/1b46fe4049e370ddb84a0b1a8925fc1321f1ad60.tar.gz"
  version "11.02.30"
  sha256 "1be456548e2df865bb1225af0b31fbd4ae4085fea75841a05ab100fc7638963c"
  license "GPL-3.0-or-later"
  version_scheme 1
  compatibility_version 1
  head "https://svn.code.sf.net/p/netpbm/code/trunk"

  livecheck do
    url "https://sourceforge.net/p/netpbm/code/HEAD/log/?path=/stable"
    regex(/Release\s+v?(\d+(?:\.\d+)+)/i)
    strategy :page_match
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "2bb73565c2911bdee88e9a226f23624c9fe4b4a39208e76564ef866b4d33d912"
    sha256 arm64_tahoe:       "fdbe8b6d5b08ede5472be2be177d83a669b3e21303da72a2d8f0a0d7cacc0323"
    sha256 arm64_sequoia:     "0e11b57ed36c5a8c460c26bbc845b4a7c48e7ad96a7ce4b5a8a0c43a74158870"
    sha256 arm64_linux:       "bda397bb2cad3e20df64e739d98af18f36cef8676bfee7eb9b94419eca60ee9a"
    sha256 x86_64_linux:      "6aa00ede2592c4361312c001a60dcbd4349e3d7f2b63400426aada91ccf51d9c"
  end

  depends_on "pkgconf" => :build
  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"

  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build
  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "jbigkit", because: "both install `pbm.5` and `pgm.5` files"

  resource "html" do
    # Rolling release, latest revision also documents previous software versions
    # Version matches the upstream SVN revision
    url "https://ghfast.top/https://github.com/jwilk-mirrors/netpbm/archive/c40c8579cba246f61135ef690eb117be4377eb02.tar.gz"
    version "5348"
    sha256 "32eb6dbee627533ce40b4f755e1f383f0e207af08cf5f2dff8a6abc2c74774d1"

    livecheck do
      url "https://sourceforge.net/p/netpbm/code/HEAD/log/?path=/userguide"
      regex(/\[r?(\d+)\]/i)
      strategy :page_match
    end
  end

  deny_network_access!

  def install
    cp "config.mk.in", "config.mk"

    inreplace "config.mk" do |s|
      s.remove_make_var! "CC"
      s.change_make_var! "TIFFLIB", "-ltiff"
      s.change_make_var! "JPEGLIB", "-ljpeg"
      s.change_make_var! "PNGLIB", "-lpng"
      s.change_make_var! "ZLIB", "-lz"
      s.change_make_var! "JASPERLIB", "-ljasper"
      s.change_make_var! "JASPERHDR_DIR", formula_opt_include("jasper")/"jasper"
      s.gsub! "/usr/local/netpbm/rgb.txt", prefix/"misc/rgb.txt"

      if OS.mac?
        s.change_make_var! "CFLAGS_SHLIB", "-fno-common"
        s.change_make_var! "NETPBMLIBTYPE", "dylib"
        s.change_make_var! "NETPBMLIBSUFFIX", "dylib"
        s.change_make_var! "LDSHLIB", "--shared -o $(SONAME)"
      else
        s.change_make_var! "CFLAGS_SHLIB", "-fPIC"
      end
    end
    inreplace "buildtools/manpage.mk", "python", "python3"

    ENV.deparallelize

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "make"
    system "make", "package", "pkgdir=#{buildpath}/stage"

    cd "stage" do
      inreplace "pkgconfig_template" do |s|
        s.gsub! "@VERSION@", File.read("VERSION").sub("Netpbm ", "").chomp
        s.gsub! "@LINKDIR@", lib
        s.gsub! "@INCLUDEDIR@", include
      end

      prefix.install %w[bin include lib misc]
      lib.install buildpath.glob("staticlink/*.a"), buildpath.glob("sharedlink/#{shared_library("*")}")
      (lib/"pkgconfig").install "pkgconfig_template" => "netpbm.pc"
    end

    # Generate unversioned library symlink (upstream does not do this)
    libnetpbm = lib.glob(shared_library("libnetpbm", "*")).reject(&:symlink?).first.basename
    lib.install_symlink libnetpbm => shared_library("libnetpbm")

    resource("html").stage buildpath/"userguide"
    make_args = %W[
      USERGUIDE=#{buildpath}/userguide
      -f
      #{buildpath}/buildtools/manpage.mk
    ]
    mkdir buildpath/"netpbmdoc" do
      system "make", *make_args, "manpages"
      [man1, man3, man5].map(&:mkpath)
      system "make", "MANDIR=#{man}", *make_args, "installman"
    end
  end

  test do
    fwrite = shell_output("#{bin}/pngtopam #{test_fixtures("test.png")} -alphapam")
    (testpath/"test.pam").write fwrite
    system bin/"pamdice", "test.pam", "-outstem", testpath/"testing"
    assert_path_exists testpath/"testing_0_0.pam"
    (testpath/"test.xpm").write <<~XPM
      /* XPM */
      static char * favicon_xpm[] = {
      "16 16 4 1",
      " 	c white",
      ".	c blue",
      "X	c black",
      "o	c red",
      "                ",
      "                ",
      "                ",
      "                ",
      "  ....    ....  ",
      " .    .  .    . ",
      ".  ..  ..  ..  .",
      "  .  . .. .  .  ",
      " .   XXXXXX   . ",
      " .   XXXXXX   . ",
      "oooooooooooooooo",
      "oooooooooooooooo",
      "oooooooooooooooo",
      "oooooooooooooooo",
      "XXXXXXXXXXXXXXXX",
      "XXXXXXXXXXXXXXXX"};
    XPM
    ppmout = shell_output("#{bin}/xpmtoppm test.xpm")
    refute_predicate ppmout, :empty?
  end
end