class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.7.19/dar-2.7.19.tar.gz"
  sha256 "601d67e7824daca586f2594a22b584703f8f6599a73e87f2afed2dfae2370889"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "742e2b959f345a3a2fec097e7e5d8da53f09e3bdbe4d50f73e4ba28b144c511b"
    sha256 arm64_sonoma:  "ad13ff36af96d4282904afb9a1dcd26efcd4919cf0eeb96c3d94ee599bd2a4f6"
    sha256 arm64_ventura: "e15954e910c558f3f6edb5434942148cdb0b1fc6f8c62864b7284f7eb96bccbb"
    sha256 sonoma:        "b14a26c01e7727833b46ec6454ddb881a395fa28cebe7cf0bf69eaee601ce4e7"
    sha256 ventura:       "811e5a25d60820886c8541e77a7343811814461daee8ba949910a6c22d4c50a8"
    sha256 arm64_linux:   "de33d89d138cc4af591df0475c1d961763067d5d17076233316e8772993185e3"
    sha256 x86_64_linux:  "ac833cce30fd512cfc0b06113b1c7e50609dae7a859000456e510b5f3be182e2"
  end

  depends_on "argon2"
  depends_on "libgcrypt"
  depends_on "lzo"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-build-html",
                          "--disable-dar-static",
                          "--disable-dependency-tracking",
                          "--disable-libxz-linking",
                          "--enable-mode=64"
    system "make", "install"
  end

  test do
    mkdir "Library"
    system bin/"dar", "-c", "test", "-R", "./Library"
    system bin/"dar", "-d", "test", "-R", "./Library"
  end
end