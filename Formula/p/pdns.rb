class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.9.8.tar.bz2"
  sha256 "180b66ae332d3166968e013bff7cbf6f0c72869d6be697db74a02df3ac6e8a91"
  license "GPL-2.0-or-later"
  revision 1

  # The first-party download page (https://www.powerdns.com/downloads) isn't
  # always updated for newer versions, so for now we have to check the
  # directory listing page where `stable` tarballs are found. We should switch
  # back to checking the download page if/when it is reliably updated with each
  # release, as it doesn't have to transfer nearly as much data.
  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "ea97dcebc54545f83e1065746545a245fbf6c72c91def9c3bfefb3915dd8f973"
    sha256 arm64_sonoma:  "29f39960409b23e872bfb95cbeab1849698441e3b34231a6ea8291e3326a355f"
    sha256 arm64_ventura: "be717db5960c7760efeb952e10468fc58c439b6b9801ab556ba3304fb1e03184"
    sha256 sonoma:        "02aa1ef5fc089ac94ebaa345c9108789d1e233362fdd3d96c5305019f84250d5"
    sha256 ventura:       "f27c289b9a1248ded18e64e895979a6c76adc88841b6a2ab44538084daa491a3"
    sha256 arm64_linux:   "34641ee4372af61fa8b05faa83c4aa469b93d3695850ae20ce9b73ce7b267fc3"
    sha256 x86_64_linux:  "cce46f4abb822c351dcfb63caf22f44af6ac6b40eca0af36811e0de17f0d645e"
  end

  head do
    url "https://github.com/powerdns/pdns.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"
  depends_on "sqlite"

  uses_from_macos "curl"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --with-lua
      --with-libcrypto=#{Formula["openssl@3"].opt_prefix}
      --with-sqlite3
      --with-modules=gsqlite3
    ]

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  service do
    run opt_sbin/"pdns_server"
    keep_alive true
  end

  test do
    output = shell_output("#{sbin}/pdns_server --version 2>&1")
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end