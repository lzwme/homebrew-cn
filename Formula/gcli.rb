class Gcli < Formula
  desc "Portable Git(hub|lab|tea) CLI tool"
  homepage "https:github.comherrhotzenplotzgcli"
  url "https:herrhotzenplotz.degclireleasesgcli-2.4.0gcli-2.4.0.tar.gz"
  sha256 "629b03b0a69d1df3c39b75517a5fc6cd254190be9e0dbde61595fe3ecddde3ce"
  license "BSD-2-Clause"

  depends_on "curl"

  def install
    system ".configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}gcli", "version"
  end
end