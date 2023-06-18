class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.22.2-source.tar.gz"
  sha256 "54c66af4e6ef8cea9867cc0320ef925d561b42919ea0d4f89db5c9ef485bbeb7"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/downloads/archive/"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2c8967042d7b53493a94e853cd2bf1bc0732415e7455efffe3b4cda06e27dcf0"
    sha256 cellar: :any,                 arm64_monterey: "8fb9229fa0b34bd527a8606fe30e5c9e04a45da46f40a0a55e1871607325f2e9"
    sha256 cellar: :any,                 arm64_big_sur:  "0834491258f233866421246146127b5e5dc72d23b67527c96452eef9b09b88bd"
    sha256 cellar: :any,                 ventura:        "f0c0f8697bd61c86f3a6626096c7ecd7342277a5d37e004d57f4859a073222ca"
    sha256 cellar: :any,                 monterey:       "5adaa74b2dbf3a03cbeab3b868fc7b8d5eeb81fef7d7f7b821a8120577d94f40"
    sha256 cellar: :any,                 big_sur:        "1feaf69bc227f87f692a916ced5c19a19203fd8b49a6f43c968b9c92d421b603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e94e0fc357a64e0b7eb299f0922896234db92ee6f4902a1076026247fcb2d18"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gumbo-parser"
  depends_on "harfbuzz"
  depends_on "jbig2dec"
  depends_on "jpeg-turbo"
  depends_on "mujs"
  depends_on "openjpeg"
  depends_on "openssl@1.1"

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