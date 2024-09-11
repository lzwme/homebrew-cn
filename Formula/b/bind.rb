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
    rebuild 1
    sha256 arm64_sequoia:  "058707bc83fb1a27a64d8af410a4301f8a403890bf8189630c5310abad07e290"
    sha256 arm64_sonoma:   "7bee803ca6e8038b4248c7f5daf5c48692493e777609dfdb2c8da31b5d213e5f"
    sha256 arm64_ventura:  "f4fc15f36f80e29543973f45ffbf59e41d5091c029d24ee3fd5f347f303b0b18"
    sha256 arm64_monterey: "aea2af3c5417f7d91cf1dbda95adb28ae793c3afb7f4c8644e44118e18039790"
    sha256 sonoma:         "08b10b928b85adb67cb414367d118b81b27e0402e373febf316d232c880d286f"
    sha256 ventura:        "57794d43fde93f918d3e2c428fa74cba9209cb23e0485eeda4fd0de3b6ee7d53"
    sha256 monterey:       "c3b363911c61b6809d567f28698c956e476452b211788f00b7d3569e17f50579"
    sha256 x86_64_linux:   "d93a2ed554374b21020ae6084a038f5ec5cc4edbd2c15a2dcbc5b95263d653f2"
  end

  depends_on "pkg-config" => :build

  depends_on "jemalloc"
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