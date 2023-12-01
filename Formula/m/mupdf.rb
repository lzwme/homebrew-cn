class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.23.7-source.tar.gz"
  sha256 "35a54933f400e89667a089a425f1c65cd69d462394fed9c0679e7c52efbaa568"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/downloads/archive/"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "07f155b5a21bef94ce9fa968e8015bfecf73164b780e81c0729df70c984fc42c"
    sha256 cellar: :any,                 arm64_ventura:  "f2e051ec60ca6a50da6f1486cf8fb00f661bdbcd667b8eef1608e5a59d36fcb7"
    sha256 cellar: :any,                 arm64_monterey: "923a472e15f2b623cbec750adadca1d6b162ee282462405ddf0a4aa6da190c18"
    sha256 cellar: :any,                 sonoma:         "4f712eb93ab173de3c6c5f13a09efa84c5c0681ee2533dd9dad68fa4e477d78d"
    sha256 cellar: :any,                 ventura:        "ce8e7c7349998d5634e61447eff9c6aa84eb4c3ee5617a50a6dea7fe6d6fd6f4"
    sha256 cellar: :any,                 monterey:       "8da2e2c0a0a2905d89d54ba270e22ce08dd7e38c810af7c8b5bf58c275b5bfde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8995084b11bae6a361a97d0a400f3a7653038a9b52be04c116e1f0e9c2d56dc"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gumbo-parser"
  depends_on "harfbuzz"
  depends_on "jbig2dec"
  depends_on "jpeg-turbo"
  depends_on "mujs"
  depends_on "openjpeg"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "freeglut"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "mesa"
  end

  conflicts_with "mupdf-tools",
    because: "mupdf and mupdf-tools install the same binaries"

  def install
    # Remove bundled libraries excluding `extract` and "strongly preferred" `lcms2mt` (lcms2 fork)
    keep = %w[extract lcms2]
    (buildpath/"thirdparty").each_child { |path| path.rmtree if keep.exclude? path.basename.to_s }

    args = %W[
      build=release
      shared=yes
      verbose=yes
      prefix=#{prefix}
      CC=#{ENV.cc}
      USE_SYSTEM_LIBS=yes
      USE_SYSTEM_MUJS=yes
    ]
    # Build only runs pkg-config for libcrypto on macOS, so help find other libs
    if OS.mac?
      [
        ["FREETYPE", "freetype2"],
        ["GUMBO", "gumbo"],
        ["HARFBUZZ", "harfbuzz"],
        ["LIBJPEG", "libjpeg"],
        ["OPENJPEG", "libopenjp2"],
      ].each do |argname, libname|
        args << "SYS_#{argname}_CFLAGS=#{Utils.safe_popen_read("pkg-config", "--cflags", libname).strip}"
        args << "SYS_#{argname}_LIBS=#{Utils.safe_popen_read("pkg-config", "--libs", libname).strip}"
      end
    end
    system "make", "install", *args

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"

    lib.install_symlink lib/shared_library("libmupdf") => shared_library("libmupdf-third")
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end