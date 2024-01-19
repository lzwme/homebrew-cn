class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://secure.nic.cz/files/knot-dns/knot-3.3.3.tar.xz"
  sha256 "aab40aab2acd735c500f296bacaa5c84ff0488221a4068ce9946e973beacc5ae"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]
  revision 1

  livecheck do
    url "https://secure.nic.cz/files/knot-dns/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "73c05c32c68e1f6c63edc1dda9c4ff92d22be3bc000effdd668dd4713373046e"
    sha256 arm64_ventura:  "6380921a8eac97775e7dec4f1a6723fa67806d3a33c95f657629a682db7e360e"
    sha256 arm64_monterey: "742de389afd7c2fa0f6d2dcf648f05881a8192a1a579e5f92692adf5a60bbc78"
    sha256 sonoma:         "2e82470bbd2bddae8ef0c027f5b4ea0eb62e947b9bbe8d7d201345068e576471"
    sha256 ventura:        "6bd6f9ec190e3fced19330def0abf35d6fe391412ff92feaba98ab13f34cf4cf"
    sha256 monterey:       "ddfa8ce8e634da61503ee776174d014d3a673f1df61d433eb16f852b1aa25986"
    sha256 x86_64_linux:   "3da067be216d1bb802268bdd8c929b5b52f81325be63cdfdc5a0ff5f46ea5c48"
  end

  head do
    url "https://gitlab.nic.cz/knot/knot-dns.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "fstrm"
  depends_on "gnutls"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "lmdb"
  depends_on "protobuf-c"
  depends_on "userspace-rcu"

  uses_from_macos "libedit"

  # build patch to use `IPV6_PKTINFO` on macOS
  # submitted issue and build patch via https://gitlab.nic.cz/knot/knot-dns/-/issues/909
  patch :DATA

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-configdir=#{etc}",
                          "--with-storage=#{var}/knot",
                          "--with-rundir=#{var}/run/knot",
                          "--prefix=#{prefix}",
                          "--with-module-dnstap",
                          "--enable-dnstap",
                          "--enable-quic"

    inreplace "samples/Makefile", "install-data-local:", "disable-install-data-local:"

    system "make"
    system "make", "install"
    system "make", "install-singlehtml"

    (buildpath/"knot.conf").write(knot_conf)
    etc.install "knot.conf"
  end

  def post_install
    (var/"knot").mkpath
  end

  def knot_conf
    <<~EOS
      server:
        rundir: "#{var}/knot"
        listen: [ "0.0.0.0@53", "::@53" ]

      log:
        - target: "stderr"
          any: "info"

      control:
        listen: "knot.sock"

      template:
        - id: "default"
          storage: "#{var}/knot"
    EOS
  end

  service do
    run opt_sbin/"knotd"
    require_root true
    input_path "/dev/null"
    log_path "/dev/null"
    error_log_path var/"log/knot.log"
  end

  test do
    system bin/"kdig", "@94.140.14.140", "www.knot-dns.cz", "+quic"
    system bin/"khost", "brew.sh"
    system sbin/"knotc", "conf-check"
  end
end

__END__
diff --git a/src/knot/server/quic-handler.c b/src/knot/server/quic-handler.c
index 0944900..f8ab263 100644
--- a/src/knot/server/quic-handler.c
+++ b/src/knot/server/quic-handler.c
@@ -13,6 +13,9 @@
     You should have received a copy of the GNU General Public License
     along with this program.  If not, see <https://www.gnu.org/licenses/>.
  */
+#ifdef __APPLE__
+#define __APPLE_USE_RFC_3542 /* to use IPV6_PKTINFO */
+#endif

 #include <netinet/in.h>
 #include <string.h>
diff --git a/src/knot/server/udp-handler.c b/src/knot/server/udp-handler.c
index 3b06fa9..5d85877 100644
--- a/src/knot/server/udp-handler.c
+++ b/src/knot/server/udp-handler.c
@@ -14,7 +14,9 @@
     along with this program.  If not, see <https://www.gnu.org/licenses/>.
  */

-#define __APPLE_USE_RFC_3542
+#ifdef __APPLE__
+#define __APPLE_USE_RFC_3542 /* to use IPV6_PKTINFO */
+#endif

 #include <assert.h>
 #include <dlfcn.h>