class Gcli < Formula
  desc "Portable Git(hub|lab|tea) CLI tool"
  homepage "https:github.comherrhotzenplotzgcli"
  url "https:herrhotzenplotz.degclireleasesgcli-2.2.0gcli-2.2.0.tar.gz"
  sha256 "05ed9a0aae58fbfe4d4966c0f157dc3c32cec8cdfa551f3b005e737f9f30c08a"
  license "BSD-2-Clause"

  depends_on "curl"

  def install
    system ".configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}gcli", "version"
  end
end