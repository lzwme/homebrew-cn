class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftp.gnu.org/gnu/texinfo/texinfo-7.1.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/texinfo/texinfo-7.1.1.tar.xz"
  sha256 "31ae37e46283529432b61bee1ce01ed0090d599e606fc6a29dca1f77c76a6c82"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "86e1d9c9fadd4254c9041dada352b019d21f55c0d9e322c89aa1c6ee37d98929"
    sha256 arm64_sonoma:   "6390c0f99e487620c1ab5471117786f8155eef3bc252be0f19a2f85839678466"
    sha256 arm64_ventura:  "609fbc841b8caa53166976593f38e3b2a180f7a1fd0810eb5a42a3a1c4ed0b31"
    sha256 arm64_monterey: "f0595a72efd5e41c0eea39fc5b91dec688dd3ac46139654504f5cde2f168c3db"
    sha256 sonoma:         "b6d2c72b0b1002d1792ee4a77f66f94b768f9ee7db02be49802015eedac0abe8"
    sha256 ventura:        "a61657f46186aa315cce906490c62518a038c52b8701a0239338fbe52e829025"
    sha256 monterey:       "0bc745d2f4832de01270c41ba136c4f59be478b416342448d61b4b7e5c191fd1"
    sha256 x86_64_linux:   "7a870bba36f9be99ca36018004d5ac591818279fd71725e4a3269e965281cace"
  end

  uses_from_macos "ncurses"
  uses_from_macos "perl"

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

    system bin/"makeinfo", "test.texinfo"
    assert_match "Hello World!", (testpath/"test.info").read
  end
end