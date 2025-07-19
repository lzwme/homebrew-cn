class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"

  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.

  url "https://downloads.isc.org/isc/bind9/9.20.11/bind-9.20.11.tar.xz"
  sha256 "4da2d532e668bc21e883f6e6d9d3d81794d9ec60b181530385649a56f46ee17a"
  license "MPL-2.0"
  revision 1
  version_scheme 1
  head "https://gitlab.isc.org/isc-projects/bind9.git", branch: "main"

  # BIND indicates stable releases with an even-numbered minor (e.g., x.2.x)
  # and the regex below only matches these versions.
  livecheck do
    url "https://www.isc.org/download/"
    regex(/href=.*?bind[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "ec86c918acab962d82267f20bf3b2baad077dacfbc2ce5968c4ec841dde34b89"
    sha256 arm64_sonoma:  "736a239a4027b77698f52503a8103844702c51566eba9e628ea2aef528d4f34e"
    sha256 arm64_ventura: "7a4119bce30046c23d032198dd165e3e16295308ddb2d28f8e86d6e2bcb864ec"
    sha256 sonoma:        "2b6cddfc3f454c4b0e46ed80b05671d07b070de3b410b34173012a92f2b8600e"
    sha256 ventura:       "d58dcf153aef18b184dab9e869da55b90ae111ee7e83ff803439ecfba367991d"
    sha256 arm64_linux:   "07b07a13b4d712a1d4b5ee038a2634eab381dcae30a0964b0cb3357c4c3c1b4a"
    sha256 x86_64_linux:  "1f4bbe94883a40c0ad6d5f7d8a74e190752a8d72b284742593d1fb0cda2bbd5b"
  end

  depends_on "pkgconf" => :build

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
    # Apply macOS 15+ libxml2 deprecation to all macOS versions.
    # This allows our macOS 14-built Intel bottle to work on macOS 15+
    # and also cover the case where a user on macOS 14- updates to macOS 15+.
    ENV.append_to_cflags "-DLIBXML_HAS_DEPRECATED_MEMORY_ALLOCATION_FUNCTIONS" if OS.mac?

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