class Libcmis < Formula
  desc "CC++ CMIS client library"
  homepage "https:github.comtdflibcmis"
  url "https:github.comtdflibcmisreleasesdownloadv0.6.2libcmis-0.6.2.tar.gz"
  sha256 "f89d871f14de3180fa5a122ab1209fc397f3abeea182db936ca1d81970be1ff0"
  license "MPL-1.1"

  depends_on "cppunit" => :build
  depends_on "docbook2x" => :build
  depends_on "boost"
  depends_on "curl"
  depends_on "libxml2"

  def install
    system ".configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}cmis-client", "--help"
  end
end