class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2512.0.tar.gz"
  sha256 "93c50025d90b6c795fa350d56a3d832bfce45043ea9bd68240d9c2a9394bc629"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "60a778adbe7b3783456ad78d41333f51d64a535d7e86177c2452d7c818d1c9f8"
    sha256 arm64_sequoia: "78386ab0d72e5c4448628c7238da387b3424dcbf44291d4c42b73ffb80ce9a55"
    sha256 arm64_sonoma:  "aa3fd3a7ac953ee37c6a1f50f17258ea2a160447e06df41378f4b8469336375a"
    sha256 sonoma:        "2fe644d53b816a2118fd94cf39fc5d51948d57bcd94f79ca9c47fcb1e3e4cf58"
    sha256 arm64_linux:   "23d47dd00ff1499ee28e42a8de7771d4487972c5e18989c7ad3e496d51684d36"
    sha256 x86_64_linux:  "2ada95d8259c5bd25bbde50bb37d5414d0add45a97c2183cec2dbb6f8b0a8f08"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "libestr"
  depends_on "libfastjson"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
      *.* #{var}/log/rsyslog-remote.log
    EOS
    etc.install buildpath/"rsyslog.conf"

    (var/"run").mkpath
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