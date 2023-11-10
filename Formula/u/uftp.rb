class Uftp < Formula
  desc "Secure, reliable, efficient multicast file transfer program"
  homepage "https://uftp-multicast.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/uftp-multicast/source-tar/uftp-5.0.2.tar.gz"
  sha256 "57c12a6ae59942535fb5e620381aedeb17d50009ee71f236427ce237a46c0b14"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :stable
    regex(%r{url=.*?/uftp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "790ea90d88cab0ffbbc9447962a70801172bccb2c7d9d0ec2cc3c976b9bcbef6"
    sha256 cellar: :any,                 arm64_ventura:  "5ee235c6c2eb1e75971de8c50eb83c7fb9cd185d26f435f53d1e55935c7e5f68"
    sha256 cellar: :any,                 arm64_monterey: "d54e3948833367dd48ac946b703db270e9167f1ebcb6ada6fc5d94759476573d"
    sha256 cellar: :any,                 sonoma:         "5fd1aac29f9aa402b255ce42a1de67f3b89820bafe09521a0bfdc2fda01861b3"
    sha256 cellar: :any,                 ventura:        "39c360adf415fc99b299fa8f9c03bf2728ecfa02ba831661744944b559f61eb4"
    sha256 cellar: :any,                 monterey:       "84ef21780e33b5b4fb251c6220e5c691f68d0026fb92f49c9e9b2508dcc86838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4e8fc19904371e7b7a4635792a10c009cfcab627631a76969a14bac81f05ce9"
  end

  depends_on "openssl@3"

  def install
    system "make", "OPENSSL=#{Formula["openssl@3"].opt_prefix}", "DESTDIR=#{prefix}", "install"
    # the makefile installs into DESTDIR/usr/..., move everything up one and remove usr
    # the project maintainer was contacted via sourceforge on 12-Feb, he responded WONTFIX on 13-Feb
    prefix.install (prefix/"usr").children
    (prefix/"usr").unlink
  end

  service do
    run [opt_bin/"uftpd", "-d"]
    keep_alive true
    working_dir var
  end

  test do
    system "#{bin}/uftp_keymgt"
  end
end