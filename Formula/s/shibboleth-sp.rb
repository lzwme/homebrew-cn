class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "https://shibboleth.net/downloads/service-provider/3.5.0/shibboleth-sp-3.5.0.tar.bz2"
  sha256 "f301604bd17ee4d94a66e6dd7ad1c3f0917949a4a12176d55614483d78fefe58"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://shibboleth.net/downloads/service-provider/latest/"
    regex(/href=.*?shibboleth-sp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "4775f63d70a8545c0b34b3b4f942ad3fc27775c131c0d7b1e7f1fd433060ca96"
    sha256 arm64_sonoma:  "c5622bcc552c92e4745d9b25dcb3fd57a8e12792fab73061edd4472376440319"
    sha256 arm64_ventura: "167477db348c5448a0b7dbe9a833d6e0ce44d9dc4dedb2e2d39d68af82000d1f"
    sha256 sonoma:        "a342bcc063d8ecb1862ffeae5a6f9f17df629c18161193ad39e3e31ae46610cf"
    sha256 ventura:       "55bce7112b26166fc371d99c249a454b21c55dd537d1eeecb73c2a6d57690c5c"
    sha256 x86_64_linux:  "69d911cc442e756b45296634942bd2ed5aff3b3d3ec2d930f086c6f6e12325f2"
  end

  depends_on "pkgconf" => :build

  depends_on "apr"
  depends_on "apr-util"
  depends_on "boost"
  depends_on "httpd"
  depends_on "log4shib"
  depends_on "opensaml"
  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "xml-tooling-c"

  uses_from_macos "krb5"

  def install
    ENV.cxx11

    args = %W[
      --disable-silent-rules
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      --with-xmltooling=#{Formula["xml-tooling-c"].opt_prefix}
      --with-saml=#{Formula["opensaml"].opt_prefix}
      --enable-apache-24
      --with-apxs24=#{Formula["httpd"].opt_bin}/apxs
      DYLD_LIBRARY_PATH=#{lib}
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  def post_install
    (var/"run/shibboleth/").mkpath
    (var/"cache/shibboleth").mkpath
  end

  service do
    run [opt_sbin/"shibd", "-F", "-f", "-p", var/"run/shibboleth/shibd.pid"]
    keep_alive true
    require_root true
  end

  test do
    system sbin/"shibd", "-t"
  end
end