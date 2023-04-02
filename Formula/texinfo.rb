class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftp.gnu.org/gnu/texinfo/texinfo-7.0.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/texinfo/texinfo-7.0.2.tar.xz"
  sha256 "f211ec3261383e1a89e4555a93b9d017fe807b9c3992fb2dff4871dae6da54ad"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "c3c103a9c5913ccc168665018c361c029a2610ad14334134ccc5402535cb9d31"
    sha256 arm64_monterey: "cc2adcdfb26c8ae4610e90d0ca8df1c7b95dd6c47b4602dde5c97979d16b8ca6"
    sha256 arm64_big_sur:  "d090847ae2a75ae30277f51765807d6053b8ca04e2a071480d08cbc12ab0678b"
    sha256 ventura:        "10697319f8e34f5b703561638883f8f19cd2715971d5ef61bdbcef328b3c57c7"
    sha256 monterey:       "0e64682b8f0b350e96f378e273467aedce6ff1acda145d52b16f7deb4e9c42f0"
    sha256 big_sur:        "60f5b22d7030b793db0a2ccb135359da3302e949b9c50ceb769d77de36a9a225"
    sha256 x86_64_linux:   "934fbc5a432eef316efbfae33efe5235294e67e750950e98b0dc28d51b14c989"
  end

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  # texinfo has been removed from macOS Ventura.
  on_monterey :or_older do
    keg_only :provided_by_macos
  end

  on_system :linux, macos: :high_sierra_or_older do
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-install-warnings",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install Dir["doc/refcard/txirefcard*"]
  end

  def post_install
    info_dir = HOMEBREW_PREFIX/"share/info/dir"
    info_dir.delete if info_dir.exist?
    info_dir.dirname.glob("*.info") do |f|
      quiet_system("#{bin}/install-info", "--quiet", f, info_dir)
    end
  end

  test do
    (testpath/"test.texinfo").write <<~EOS
      @ifnottex
      @node Top
      @top Hello World!
      @end ifnottex
      @bye
    EOS
    system "#{bin}/makeinfo", "test.texinfo"
    assert_match "Hello World!", File.read("test.info")
  end
end