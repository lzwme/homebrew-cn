class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"

  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.

  url "https://downloads.isc.org/isc/bind9/9.20.1/bind-9.20.1.tar.xz"
  sha256 "fe6ddff74921410d33b62b5723ac23912e8d50138ef66d7a30dc2c421129aeb0"
  license "MPL-2.0"
  version_scheme 1
  head "https://gitlab.isc.org/isc-projects/bind9.git", branch: "main"

  # BIND indicates stable releases with an even-numbered minor (e.g., x.2.x)
  # and the regex below only matches these versions.
  livecheck do
    url "https://www.isc.org/download/"
    regex(/href=.*?bind[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "411094ff09b5e13c0822343935770d83043aab92c24329a3dc8010adcb572584"
    sha256 arm64_ventura:  "5657d7422c79c3bb6286fdb0064c1e81737bc2f52d7637bb3f4af19164eecb3b"
    sha256 arm64_monterey: "f7a3f597c42e0b9f514a0ed8a0f5d7d8a6b31a58133de070602ccfc90492af99"
    sha256 sonoma:         "fa165fcdbdf6ef677ba8ca5e59cf1e785507fe68966d922d43ff770deab8d8f8"
    sha256 ventura:        "9ec7c2cafc3307641e489f7023f72df35c9b69f1018ceb3cccb9ce3a12d69e87"
    sha256 monterey:       "f9bd9d62f1a914c4acfbe624214f0237bf4aa3f396ae0f195ecf7c23c7213c52"
    sha256 x86_64_linux:   "bedf760d34e76680e5d200572e8e431261a30ee701613061cb1207e6ff9a0bfd"
  end

  depends_on "pkg-config" => :build

  depends_on "json-c"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "userspace-rcu"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libcap"
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--sysconfdir=#{pkgetc}",
      "--localstatedir=#{var}",
      "--with-json-c",
      "--with-libidn2=#{Formula["libidn2"].opt_prefix}",
      "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
      "--without-lmdb",
    ]
    system "./configure", *args

    system "make"
    system "make", "install"

    (buildpath/"named.conf").write named_conf
    system "#{sbin}/rndc-confgen", "-a", "-c", "#{buildpath}/rndc.key"
    pkgetc.install "named.conf", "rndc.key"
  end

  def post_install
    (var/"log/named").mkpath
    (var/"named").mkpath
  end

  def named_conf
    <<~EOS
      logging {
          category default {
              _default_log;
          };
          channel _default_log {
              file "#{var}/log/named/named.log" versions 10 size 1m;
              severity info;
              print-time yes;
          };
      };

      options {
          directory "#{var}/named";
      };
    EOS
  end

  service do
    run [opt_sbin/"named", "-f", "-L", var/"log/named/named.log"]
    require_root true
  end

  test do
    system bin/"dig", "-v"
    system bin/"dig", "brew.sh"
    system bin/"dig", "ü.cl"
  end
end