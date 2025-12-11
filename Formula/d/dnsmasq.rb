class Dnsmasq < Formula
  desc "Lightweight DNS forwarder and DHCP server"
  homepage "https://thekelleys.org.uk/dnsmasq/doc.html"
  url "https://thekelleys.org.uk/dnsmasq/dnsmasq-2.91.tar.gz"
  sha256 "2d26a048df452b3cfa7ba05efbbcdb19b12fe7a0388761eb5d00938624bd76c8"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://thekelleys.org.uk/dnsmasq/"
    regex(/href=.*?dnsmasq[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "1fc3abe9a474251aeb4979e50a9b70cf87948af082fa3e5f0254f713b0e95fdc"
    sha256 arm64_sequoia: "b785296bd80d891b648da7927ace6803f604f43ea4612e74ef2fafd8a4dc31f6"
    sha256 arm64_sonoma:  "ac9befb6d7fdf93f73600545580edd512d3f945698f9d4b335c602028f68e91c"
    sha256 sonoma:        "bfefd73ce943255a2e67834d26f2e07ac02023ef9bfa3747969d035b9914a065"
    sha256 arm64_linux:   "9dc2c044fc89c0163cd967ab4dc09ec9a756297cacd4c9a9eb3de8317a9aafc4"
    sha256 x86_64_linux:  "34e0fc6ec9cdff68e1e5711f56f7e2a484c1cece80b1222e71e248c9c2509e83"
  end

  depends_on "pkgconf" => :build

  def install
    ENV.deparallelize

    # Fix etc location
    inreplace %w[dnsmasq.conf.example src/config.h man/dnsmasq.8
                 man/es/dnsmasq.8 man/fr/dnsmasq.8].each do |s|
      s.gsub! "/var/lib/misc/dnsmasq.leases",
              var/"lib/misc/dnsmasq/dnsmasq.leases", audit_result: false
      s.gsub! "/etc/dnsmasq.conf", etc/"dnsmasq.conf", audit_result: false
      s.gsub! "/var/run/dnsmasq.pid", var/"run/dnsmasq/dnsmasq.pid", audit_result: false
      s.gsub! "/etc/dnsmasq.d", etc/"dnsmasq.d", audit_result: false
      s.gsub! "/etc/ppp/resolv.conf", etc/"dnsmasq.d/ppp/resolv.conf", audit_result: false
      s.gsub! "/etc/dhcpc/resolv.conf", etc/"dnsmasq.d/dhcpc/resolv.conf", audit_result: false
      s.gsub! "/usr/sbin/dnsmasq", HOMEBREW_PREFIX/"sbin/dnsmasq", audit_result: false
    end

    # Fix compilation on newer macOS versions.
    ENV.append_to_cflags "-D__APPLE_USE_RFC_3542"

    inreplace "Makefile" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags || ""
      s.change_make_var! "LDFLAGS", ENV.ldflags || ""
    end

    system "make", "install", "PREFIX=#{prefix}"

    etc.install "dnsmasq.conf.example" => "dnsmasq.conf"
    (var/"lib/misc/dnsmasq").mkpath
    (var/"run/dnsmasq").mkpath
    (etc/"dnsmasq.d/ppp").mkpath
    (etc/"dnsmasq.d/dhcpc").mkpath
    touch etc/"dnsmasq.d/ppp/.keepme"
    touch etc/"dnsmasq.d/dhcpc/.keepme"
  end

  def caveats
    <<~EOS
      On current macOS releases, `/etc/resolver/<domain>` resolver overrides do not work if the nameserver is `127.0.0.1` and dnsmasq is running on a non-53 port.
      To use scoped resolver zones reliably, bind dnsmasq to a non-localhost IP (e.g., a loopback alias like 10.0.0.1) on port 53.
    EOS
  end

  service do
    run [opt_sbin/"dnsmasq", "--keep-in-foreground", "-C", etc/"dnsmasq.conf", "-7", etc/"dnsmasq.d,*.conf"]
    keep_alive true
    require_root true
  end

  test do
    system sbin/"dnsmasq", "--test"
  end
end