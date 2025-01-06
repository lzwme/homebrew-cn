class Gcli < Formula
  desc "Portable Git(hub|lab|tea) CLI tool"
  homepage "https:github.comherrhotzenplotzgcli"
  url "https:herrhotzenplotz.degclireleasesgcli-2.6.0gcli-2.6.0.tar.gz"
  sha256 "b1789362afebd7e5001ef8b1f1be84d79e800c4b4caaf932a364fcd5f75810aa"
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