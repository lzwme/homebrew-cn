class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.23.9-source.tar.gz"
  sha256 "d4a5d66801d85f97d76da978b155f66a5659d1131070c0400f076883f604e297"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/downloads/archive/"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "130aa77682668b879e43a80fd0f0fec853196670df8f846b76f1d2550fbb54e7"
    sha256 cellar: :any,                 arm64_ventura:  "5809ac73816ad25243bfcf91ba93f7e73cf4449c98bfa3cc0a2dd0d2c9eb55ca"
    sha256 cellar: :any,                 arm64_monterey: "ccde35d78ac32a4b3cc9ba9f431f58a8fb4d37c9b1a2eeaaaa6a926d8ad009b2"
    sha256 cellar: :any,                 sonoma:         "70b619b46eda11a7a8970a5031df0c59aa5f9c574eda26db90fd954984e61f69"
    sha256 cellar: :any,                 ventura:        "da3dd1d09e09f85c9413963346fd9eed9f06df933db586dddd7d9aba3f40620b"
    sha256 cellar: :any,                 monterey:       "bd32f87995d357808f63ee3efebac4a2292f21eab82ad758aa890501d02e8847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d14a779c77b1929dd050322d812da41314741074cb1e5f7a8242ee1408e0f58"
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