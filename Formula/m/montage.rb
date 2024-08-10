class Montage < Formula
  desc "Toolkit for assembling FITS images into custom mosaics"
  homepage "http:montage.ipac.caltech.edu"
  url "http:montage.ipac.caltech.edudownloadMontage_v6.0.tar.gz"
  sha256 "1f540a7389d30fcf9f8cd9897617cc68b19350fbcde97c4d1cdc5634de1992c6"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comCaltech-IPACMontage.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "322fc326957e3d7173087350a50a5e5c034223fe631e5e2d45556a4e3eb2a85b"
    sha256 cellar: :any,                 arm64_ventura:  "64bead5a3b77bd80dd4cdb5980ac40b4f140246a8dd77ffc91cc476e1d5201e0"
    sha256 cellar: :any,                 arm64_monterey: "979157185163a1e4af7de11b882687e34e86b5e8a185c046c8e468da8a7765f6"
    sha256 cellar: :any,                 arm64_big_sur:  "f9fb8238d49754d19175b69133cab7ac5d4a28d76cf0823894956eb9dcddc738"
    sha256 cellar: :any,                 sonoma:         "566ab3bb6bd1d8ff09fe02089a9e78540900e70a8780b777ffc60f3bbcb9db5f"
    sha256 cellar: :any,                 ventura:        "f6bc30d29752622bd772486c04d6feedf51a28bcf599571cf4b9336a21249900"
    sha256 cellar: :any,                 monterey:       "98c1ea6725fe61b926cb5ae148b6fec4dac9c3f2a05d2573395bfbe1ca3f3ef6"
    sha256 cellar: :any,                 big_sur:        "c0dae6deab1f09e34a1ba4dcebf923f697662a0b4a0f12b778cbc4eda7191d00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "896bd4dc1695ea76be99acadcf5216ceafbbc70636738bdf349e8b14b6aea7d0"
  end

  depends_on "cfitsio"
  depends_on "freetype"
  depends_on "jpeg-turbo"

  uses_from_macos "bzip2"

  conflicts_with "wdiff", because: "both install an `mdiff` executable"

  def install
    # Work around multiple definition of `fstatus'. Remove in the next release.
    # Ref: https:github.comCaltech-IPACMontagecommitf5358e2152f301ecc44dd2d7fb33ee5daecc39f5
    makefiles = %w[libsrccoordMakefile MontageMakefile.LINUX]
    inreplace makefiles, ^CC\s*=.*$, "\\0 -fcommon" if OS.linux? && build.stable?

    # Avoid building bundled libraries
    libs = %w[bzip2 cfitsio freetype jpeg]
    rm_r buildpath.glob("libsrc{#{libs.join(",")}}*")
    inreplace "libsrcMakefile", ^[ \t]*\(cd (?:#{libs.join("|")}).*\)$, ""
    inreplace "MontageLibMakefile", %r{^.*libsrc(?:#{libs.join("|")}).*$\n}, ""
    inreplace "MontageLibViewerMakefile.#{OS.kernel_name.upcase}",
              "-I....libfreetypeincludefreetype2",
              "-I#{Formula["freetype"].opt_include}freetype2"

    ENV.deparallelize # Build requires targets to be built in specific order
    system "make"
    bin.install Dir["binm*"]
  end

  def caveats
    <<~EOS
      Montage is under the CaltechJPL non-exclusive, non-commercial software
      licence agreement available at:
        http:montage.ipac.caltech.edudocsdownload.html
    EOS
  end

  test do
    system bin"mHdr", "m31", "1", "template.hdr"
  end
end