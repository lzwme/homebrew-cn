class Dvdbackup < Formula
  desc "Rip DVD's from the command-line"
  homepage "https:dvdbackup.sourceforge.net"
  url "https:downloads.sourceforge.netprojectdvdbackupdvdbackupdvdbackup-0.4.2dvdbackup-0.4.2.tar.gz"
  sha256 "0a37c31cc6f2d3c146ec57064bda8a06cf5f2ec90455366cb250506bab964550"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "bbca14aeee4082533a71f5e48ed2bc6e56ea02420179dfb09e11242e92f2fbe2"
    sha256 cellar: :any, arm64_ventura:  "e009a34c9e7cc319095b3a001b99aa8da5fecb6662ff4fa64daa75b932dbe79b"
    sha256 cellar: :any, arm64_monterey: "dd5094eec306b3cdc1e0592937f3a9c98872d703d53865575e30c4bbf7c25274"
    sha256 cellar: :any, arm64_big_sur:  "9915a81fafc6436fbc35d0cdde179fa65775b438f296e21397c3c416a900889b"
    sha256 cellar: :any, sonoma:         "57aff8713d26d9f9a88607b2e199e061cfb510cf9134293926321e36dbcd17d6"
    sha256 cellar: :any, ventura:        "31fe3266f27694ca57994af74493450a960ceda2be728926332264c83df27d06"
    sha256 cellar: :any, monterey:       "fc938674adb52e95181053700eda2db94b4cbd2ff070391201ce3cf5bbd61496"
    sha256 cellar: :any, big_sur:        "dc6778d0bf6be00d5b9abfe877b0893b37ac2a36ca3395155658572b8b050750"
    sha256 cellar: :any, catalina:       "f90daeedafee023dd908051af528be81f629f30026ec109f89e2bb187582d75b"
    sha256 cellar: :any, mojave:         "e28050e6f6611d8f8f573f52bdb17bb349a5f347b0a6499e9eaa8bfdde9a5f71"
    sha256               x86_64_linux:   "c88b2286a17892633aef4e5fae8065e813ac1bf0bf14a63e0be2566bca388d4b"
  end

  depends_on "libdvdread"

  # Fix compatibility with libdvdread 6.1.0. See:
  # https:bugs.launchpad.netdvdbackup+bug1869226
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches7d734fd4d41a331b403522249d96587a62fd85d5dvdbackupcompat.patch"
    sha256 "12d54bc08b0eb2acf6429c256373d1d98ba3f6f14821c2bebbbb571eb7b9d82b"
  end

  def install
    system ".configure", "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}dvdbackup", "--version"
  end
end