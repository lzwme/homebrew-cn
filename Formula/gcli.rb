class Gcli < Formula
  desc "Portable Git(hub|lab|tea) CLI tool"
  homepage "https://github.com/herrhotzenplotz/gcli"
  url "https://herrhotzenplotz.de/gcli/releases/gcli-2.9.1/gcli-2.9.1.tar.gz"
  sha256 "fe20b38da12a922d7e3b46c3623ff7a1a7fbe63f37471a688ca1938cc79904af"
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