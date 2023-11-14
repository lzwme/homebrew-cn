class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.23.5-source.tar.gz"
  sha256 "6e5679cdfaaef9c7e89e296395220ce2c133ed3dcad51a478667336c6eaec706"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/downloads/archive/"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4ae3bd17a21fb1bbd323443bfa80ccc64c924f0a814b24ee2e7b2ab2de3ca82c"
    sha256 cellar: :any,                 arm64_ventura:  "f4c3b2b54a29bbbddce1970be82bf7df912f93a32ee269ad8304c5784d0429d5"
    sha256 cellar: :any,                 arm64_monterey: "ad27f2ceaba514185a2978e128c8d0f3e032a06c0ffe55b25cbd4294eaf715b7"
    sha256 cellar: :any,                 sonoma:         "b6d892b321378f4496e27dabe3800d44b4c238d99e9782b494073d25b2b9a3f4"
    sha256 cellar: :any,                 ventura:        "241e281f8ca8d12fa365f321eb3e566003c7bc58d869b0469a34b6995a95a7f7"
    sha256 cellar: :any,                 monterey:       "4ec7585c55509b39dd96cbb7fe64193a135db0dadfad68935026daf96c4cae9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc72da8d4bc2787c96e9b30b25d4612f376a96e87cb173fa44978285f96bc78c"
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