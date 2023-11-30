class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "https://gtk-gnutella.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.2.2/gtk-gnutella-1.2.2.tar.xz"
  sha256 "95a5d86878f6599df649b95db126bd72b9e0cecadb96f41acf8fdcc619771eb6"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "29723e41ede038193d981a7067fb3f30241fb515511d3405bd2068004a3655ca"
    sha256 arm64_ventura:  "716b6d60e49eee2e04685351a32eda115d1006a1f7170941f6579aa10c87e3d5"
    sha256 arm64_monterey: "5a2733a7f6abb6536f4f4cd2963ea1998ea46f63b55066671565a747f4133922"
    sha256 sonoma:         "19a16264b0e7465acbb2bb49dffe155dc9feb7eaf7a5a062e8c19c8e643a8d8d"
    sha256 ventura:        "429d49588c862e7b994ad7198f3bb81863af198b928460f41f04a401756f5f7d"
    sha256 monterey:       "4354077a23b85c65dafd4b408bff6fe496d0f371bce46078ff204110380f8310"
    sha256 x86_64_linux:   "15c5a113ee3dfb9ed475958f8446e910f252f91edbee2f0d093e24a22943b388"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    ENV.deparallelize

    system "./build.sh", "--prefix=#{prefix}", "--disable-nls"
    system "make", "install"
    rm_rf share/"pixmaps"
    rm_rf share/"applications"
  end

  test do
    system "#{bin}/gtk-gnutella", "--version"
  end
end