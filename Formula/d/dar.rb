class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.8.3/dar-2.8.3.tar.gz"
  sha256 "812648f4d85fa2fe63ddad811f1c392f02c8627b54f9a610a1b54f51fbd96512"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "2a2f80d13e39c91761f63aab8a45350be1c355349ff820a04fa19d07e4ad9df2"
    sha256 arm64_sequoia: "ba86c62a1e818d6919704c30c97083f8c692d295e6b2ae01e3a476b0845c2a7c"
    sha256 arm64_sonoma:  "9280209b236ec153852431d00b2dd917d929b43e4511b8f11c8de6320f301b6b"
    sha256 sonoma:        "798e59bcfb4ce8bcf15e900a079af9fcc49fca3fcb8e1541282ac6deec0df975"
    sha256 arm64_linux:   "1c149d8560aa9326d22a7601b70d2bd77eb1175d6303b8253fa61a2ea60db849"
    sha256 x86_64_linux:  "b9ff1f19e2d1128cd528277ca8f30bf8e65d44ef41a5f3e0491176a2bb648b34"
  end

  depends_on "argon2"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "lz4"
  depends_on "lzo"
  depends_on "xz"
  depends_on "zstd"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-build-html",
                          "--disable-dar-static",
                          "--disable-dependency-tracking",
                          "--enable-mode=64"
    system "make", "install"
  end

  test do
    mkdir "Library"
    system bin/"dar", "-c", "test", "-R", "./Library"
    system bin/"dar", "-d", "test", "-R", "./Library"
  end
end