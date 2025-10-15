class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2510.0.tar.gz"
  sha256 "a70a9834186859539a6a4d1c7b3f68c23897e805829b764a45e92cb0cc95e66a"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "52b056838647afd16db626576e9b224738b9ef3031edfee90446a36c97503501"
    sha256 arm64_sequoia: "d8c7bfbaf7c2c384773cec928525e9b19b1ca0aa7b026271420d209eb07a29c5"
    sha256 arm64_sonoma:  "aca061f730511b05e2e00a49239fdc2edc2a6f10bfed2faf09411e9b3a9dd90d"
    sha256 sonoma:        "6e92f72b192788e7f4e0d65b2628b8ef8ee2dff0a2692f71464f0ed42dc87920"
    sha256 arm64_linux:   "26ee6cabef387da7870b9570cf85220a146af9114ca58107a35751b7164d50f4"
    sha256 x86_64_linux:  "c71f794e6984ae53eeb1cd0d7ef77a4a58a68a10b313454b35c6f330e6efd06e"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "libestr"
  depends_on "libfastjson"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "./configure", "--enable-imfile",
                          "--enable-usertools",
                          "--enable-diagtools",
                          "--disable-uuid",
                          "--disable-libgcrypt",
                          "--enable-gnutls",
                          *std_configure_args
    system "make"
    system "make", "install"

    (buildpath/"rsyslog.conf").write <<~EOS
      # minimal config file for receiving logs over UDP port 10514
      $ModLoad imudp
      $UDPServerRun 10514
      *.* /usr/local/var/log/rsyslog-remote.log
    EOS
    etc.install buildpath/"rsyslog.conf"
  end

  def post_install
    mkdir_p var/"run"
  end

  service do
    run [opt_sbin/"rsyslogd", "-n", "-f", etc/"rsyslog.conf", "-i", var/"run/rsyslogd.pid"]
    keep_alive true
    error_log_path var/"log/rsyslogd.log"
    log_path var/"log/rsyslogd.log"
  end

  test do
    result = shell_output("#{opt_sbin}/rsyslogd -f #{etc}/rsyslog.conf -N 1 2>&1")
    assert_match "End of config validation run", result
  end
end