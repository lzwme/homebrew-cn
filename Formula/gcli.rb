class Gcli < Formula
  desc "Portable Git(hub|lab|tea) CLI tool"
  homepage "https:github.comherrhotzenplotzgcli"
  url "https:herrhotzenplotz.degclireleasesgcli-2.5.0gcli-2.5.0.tar.gz"
  sha256 "6af6b46e63d3ff24fcd3534c80b19030387590b744dcdc45f288fedd39bb15d7"
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