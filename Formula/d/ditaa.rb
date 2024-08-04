class Ditaa < Formula
  desc "Convert ASCII diagrams into proper bitmap graphics"
  homepage "https:ditaa.sourceforge.net"
  url "https:github.comstathissiderisditaareleasesdownloadv0.11.0ditaa-0.11.0-standalone.jar"
  sha256 "9418aa63ff6d89c5d2318396f59836e120e75bea7a5930c4d34aa10fe7a196a9"
  license "LGPL-3.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "4e03eed43d92f5622e98144174fcd5f40dfb2b0bbdcb819aa5b59ec61d5fb632"
  end

  depends_on "openjdk"

  def install
    libexec.install "ditaa-#{version}-standalone.jar"
    (bin"ditaa").write <<~EOS
      #!binbash
      exec "#{Formula["openjdk"].opt_bin}java" -jar "#{libexec}ditaa-#{version}-standalone.jar" "$@"
    EOS
  end

  test do
    system bin"ditaa", "-help"
  end
end