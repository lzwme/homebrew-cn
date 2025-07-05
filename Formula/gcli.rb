class Gcli < Formula
  desc "Portable Git(hub|lab|tea) CLI tool"
  homepage "https://github.com/herrhotzenplotz/gcli"
  url "https://herrhotzenplotz.de/gcli/releases/gcli-2.8.0/gcli-2.8.0.tar.gz"
  sha256 "d00802b3c582a925f92836f5028c723b5ae3b7979c52e28ac20c3e3fb00423ab"
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