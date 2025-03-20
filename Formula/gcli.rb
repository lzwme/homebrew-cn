class Gcli < Formula
  desc "Portable Git(hub|lab|tea) CLI tool"
  homepage "https:github.comherrhotzenplotzgcli"
  url "https:herrhotzenplotz.degclireleasesgcli-2.7.0gcli-2.7.0.tar.gz"
  sha256 "bf35376ef05228c336538459f8262165e6f10f1844a4c79582f4b5de91d25d79"
  license "BSD-2-Clause"

  depends_on "curl"
  depends_on "pkgconf"

  def install
    system ".configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin"gcli", "version"
  end
end