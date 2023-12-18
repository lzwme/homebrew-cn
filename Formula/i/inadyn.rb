class Inadyn < Formula
  desc "Dynamic DNS client with IPv4, IPv6, and SSLTLS support"
  homepage "https:troglobit.comprojectsinadyn"
  url "https:github.comtroglobitinadynreleasesdownloadv2.12.0inadyn-2.12.0.tar.xz"
  sha256 "e64c4386b6f42bbace589b847f22823a755b59f14a277a5f556fef0d99069245"
  license all_of: ["GPL-2.0-or-later", "ISC", "MIT"]

  bottle do
    sha256 arm64_sonoma:   "fe1fce79f66da620c913fbdb957e248a86c230c11811c816abb71a0b7917f787"
    sha256 arm64_ventura:  "174182adaa5fe0f4109350449a22af67979963cfff2d1c061ea2831c1657921c"
    sha256 arm64_monterey: "11427c528e6354558c3031729130274e52d3fa304801523c0bc9305a11ea0352"
    sha256 arm64_big_sur:  "17bdc871fa2a0195a3fc5aad3a3088d3fd82bf82373abab194cd886a34fe8f72"
    sha256 sonoma:         "7b34e39f010411c1e0353ee2c82926082244e4a912c56a27452e464b838e1d25"
    sha256 ventura:        "37916b230975cb4d718b41108b1e6a98b475f27e9c731285fd286e572af414ec"
    sha256 monterey:       "b50296e99a5e8841ffa158c7d29a0ad6532cd5cbcc430dd1dabee8a8c792d22f"
    sha256 big_sur:        "e026b42611ff126596674a9aee10b6c33321bb471d8ed3f27836014dec1b4eeb"
    sha256 x86_64_linux:   "056482287ad8f58d2ffd63ab62d28f9e0d136ddfce39eb884265e9e9c7ffafe9"
  end

  head do
    url "https:github.comtroglobitinadyn.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "gnutls"

  def install
    mkdir_p buildpath"inadynm4"
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system ".configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  test do
    system sbin"inadyn", "--check-config", "--config=#{doc}examplesinadyn.conf"
  end
end