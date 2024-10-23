class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2410.0.tar.gz"
  sha256 "b6be03c766df4cde314972c1c01cb74f3eacf8aec57066c0c12be0e079726eba"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "bf23848060b3933422568eff4b627bec310b40ccd85072624ba51382b8155286"
    sha256 arm64_sonoma:  "b054056b82837a58c6b0d5f1f0c7db8a64354e1da587fce0aeb7b7fdaf13691c"
    sha256 arm64_ventura: "233a329a67dc14f13b448df6fa7181474714ed8b156d7165792aa5af894efc1e"
    sha256 sonoma:        "16c866c23e8c7b411553a3324f1b07771f9d764db809222758c4dec6585b8e9c"
    sha256 ventura:       "7186969ea0ac5950fb3aec7aa3bba1043621eb6df6bb402dc1a4a598553d5beb"
    sha256 x86_64_linux:  "178bd0caa4693283111914bba31ea5625f3c3d52ef4f9fbe004e36208160fc70"
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libestr"
  depends_on "libfastjson"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--enable-imfile",
                          "--enable-usertools",
                          "--enable-diagtools",
                          "--disable-uuid",
                          "--disable-libgcrypt",
                          "--enable-gnutls"
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