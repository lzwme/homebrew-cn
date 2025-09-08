class Gcli < Formula
  desc "Portable Git(hub|lab|tea) CLI tool"
  homepage "https://github.com/herrhotzenplotz/gcli"
  url "https://herrhotzenplotz.de/gcli/releases/gcli-2.9.0/gcli-2.9.0.tar.gz"
  sha256 "d830ca0d2530ad116d21c16bfcabd3eae44c6c00825979221f33b399fc9bde32"
  license "BSD-2-Clause"

  depends_on "curl"
  depends_on "pkgconf"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"gcli", "version"
  end
end