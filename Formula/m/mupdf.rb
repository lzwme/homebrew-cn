class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.26.0-source.tar.gz"
  sha256 "d896f89eabfc5aaaabcdddc30f4592f6df33075640759292dd338d8e69e59c63"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/releases"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e773216e231cdc4ea471d63edddc90a67ad6bc0d990b9e14a163c4952e60738c"
    sha256 cellar: :any,                 arm64_sonoma:  "046e8262a45c3b24d3ad077eb2e6addaa43d6b778f518c6bb433ffbab2da2b87"
    sha256 cellar: :any,                 arm64_ventura: "18aea7bc53249cefaf910f26c3da52fe77dec817990d16f35f97196cdf71b61b"
    sha256 cellar: :any,                 sonoma:        "e25e8958256ec743cdc880d63dc68204a4bc82710a91454aece8851295c1d6c8"
    sha256 cellar: :any,                 ventura:       "13cfb67461ebc03a94eb4773c781649cc0eef12781ea2efcf1fe0d8130b1143a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "875be13108d7114c44c1348db764c5818f41f235f6065605f7551ad1f6779dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04febebca733ebaaa2fd1d3650165ce160a0bc058fb05b264d0e0dada1a1ec31"
  end

  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "swig" => :build
  depends_on "brotli"
  depends_on "freetype"
  depends_on "gumbo-parser"
  depends_on "harfbuzz"
  depends_on "jbig2dec"
  depends_on "jpeg-turbo"
  depends_on "leptonica"
  depends_on "mujs"
  depends_on "openjpeg"
  depends_on "openssl@3"
  depends_on "python@3.13"
  depends_on "tesseract"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libarchive"
  end

  on_linux do
    depends_on "freeglut"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "mesa"
  end

  conflicts_with "mupdf-tools", because: "both install the same binaries"

  def install
    # Remove bundled libraries excluding `extract` and "strongly preferred" `lcms2mt` (lcms2 fork)
    keep = %w[extract lcms2]
    (buildpath/"thirdparty").each_child { |path| rm_r(path) if keep.exclude? path.basename.to_s }

    # For python bindings needed by `pymupdf`: https://pymupdf.readthedocs.io/en/latest/packaging.html
    site_packages = Language::Python.site_packages("python3.13")
    ENV.prepend_path "PYTHONPATH", Formula["llvm"].opt_prefix/site_packages

    args = %W[
      build=release
      shared=yes
      tesseract=yes
      verbose=yes
      prefix=#{prefix}
      pydir=#{prefix/site_packages}
      CC=#{ENV.cc}
      USE_SYSTEM_LIBS=yes
      USE_SYSTEM_MUJS=yes
      VENV_FLAG=
    ]

    # Build only runs pkg-config for libcrypto on macOS, so help find other libs
    if OS.mac?
      [
        ["FREETYPE", "freetype2"],
        ["GUMBO", "gumbo"],
        ["HARFBUZZ", "harfbuzz"],
        ["LEPTONICA", "lept"],
        ["LIBJPEG", "libjpeg"],
        ["OPENJPEG", "libopenjp2"],
        ["TESSERACT", "tesseract"],
      ].each do |argname, libname|
        args << "SYS_#{argname}_CFLAGS=#{Utils.safe_popen_read("pkgconf", "--cflags", libname).strip}"
        args << "SYS_#{argname}_LIBS=#{Utils.safe_popen_read("pkgconf", "--libs", libname).strip}"
        args << "HAVE_SYS_#{argname}=yes"
      end

      # Workarounds since build scripts for Python bindings don't support macOS
      # Issue ref: https://bugs.ghostscript.com/show_bug.cgi?id=705376
      inreplace "Makefile" do |s|
        # Avoid creating a symlink that overwrites installed file
        s.gsub!(/^\s*ln -sf libmupdf/, "#\\0")

        # FIXME: libmupdfcpp should be a shared lib (.dylib) while _mupdf should be a bundle
        # (.so) as the former is a C++ library installed into `lib` while latter is loaded by
        # Python bindings. However, the python build scripts hardcode `.so` and uses `-shared`
        # which result in neither being correct. Also, the Makefile installs with $(SO) which
        # fails to find `.so`. For now we do the easier workaround of installing as `.so`.
        s.gsub! "libmupdfcpp.$(SO)", "libmupdfcpp.so"
        s.gsub! "_mupdf.$(SO)", "_mupdf.so"
      end

      ENV.cxx11
    end

    system "make", "install", *args
    system "make", "install-shared-python", *args

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"

    lib.install_symlink lib/shared_library("libmupdf") => shared_library("libmupdf-third")
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end