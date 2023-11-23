class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.23.6-source.tar.gz"
  sha256 "ac11eb859dd404488e5153cdc9651bb4341e5baaf4d3b3f27e2afc82f9aadc29"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/downloads/archive/"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aeca2202987644e61fd42f493f890c4e3fa9796aa435ae3b7a9d47732225808e"
    sha256 cellar: :any,                 arm64_ventura:  "d618feb71da11c4c9b45f9f936e3b04dfe88ae429ffd9d163f03b34aad793846"
    sha256 cellar: :any,                 arm64_monterey: "23b5aac1d9b79b3b1101f3e2f1a3e58bf3f73e04409e42e7f3f8e7d4c3485039"
    sha256 cellar: :any,                 sonoma:         "031d3d90f18c2253bc8bafc23def5439146750a8e306256ec70167a6141915df"
    sha256 cellar: :any,                 ventura:        "58865ff7457c54943889e03ef98f43b85e2fa89b80effc410f8160bb3b6e8736"
    sha256 cellar: :any,                 monterey:       "8cdbfa312caee4bf3a91540b7e4c386ff85bcdf1b6e0b44c824f4ca1cb5a2888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cd4aa1bb118084cf0e33e56ab7ab385da228a7ca8f8e2e63d8a0a47fa9cd6f2"
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