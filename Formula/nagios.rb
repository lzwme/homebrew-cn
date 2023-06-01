class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nagios-4.x/nagios-4.4.12/nagios-4.4.12.tar.gz"
  sha256 "1c890e5d40d59aacb6862ea3554b9e0bc98760a047c34c9efe8688e104cd23b3"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/nagios[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "f08d64123d98a0d4c33966150f12f6c978fe915eae9b6ed971d036d180938dac"
    sha256 arm64_monterey: "3fe130d2d0f3080e2fb3de635a3e8ae10e6a26150b999e03410ab52fc7a9a06a"
    sha256 arm64_big_sur:  "186e1c38168335bf3f73d6fdb3c2c4febcc01de7ba063bf4b5d473964ead5513"
    sha256 ventura:        "64dda450a7f09a21f494045152a51554f7da3f7607ea5dceae7fc9b86d1d16bb"
    sha256 monterey:       "680fae3dbeb6c05ddf0b9ff1e63be175ac88a6e8ae8d002e34e688b5f966d3d4"
    sha256 big_sur:        "edd5580d99c1ecceaf14896c1f640ed2152b2b4537f56fd8dce06cb3f2b9ba55"
    sha256 x86_64_linux:   "f3e7dea0b9647f6977dfcf116c11d167c75cc3408eac8fc5660237848dc95140"
  end

  depends_on "gd"
  depends_on "libpng"
  depends_on "nagios-plugins"
  depends_on "openssl@3"

  uses_from_macos "unzip"

  def nagios_sbin
    prefix/"cgi-bin"
  end

  def nagios_etc
    etc/"nagios"
  end

  def nagios_var
    var/"lib/nagios"
  end

  def htdocs
    pkgshare/"htdocs"
  end

  def user
    Utils.safe_popen_read("id", "-un").chomp
  end

  def group
    Utils.safe_popen_read("id", "-gn").chomp
  end

  def install
    args = [
      "--sbindir=#{nagios_sbin}",
      "--sysconfdir=#{nagios_etc}",
      "--localstatedir=#{nagios_var}",
      "--datadir=#{htdocs}",
      "--libexecdir=#{HOMEBREW_PREFIX}/sbin", # Plugin dir
      "--with-cgiurl=/nagios/cgi-bin",
      "--with-htmurl=/nagios",
      "--with-nagios-user=#{user}",
      "--with-nagios-group='#{group}'",
      "--with-command-user=#{user}",
      "--with-httpd-conf=#{share}",
      "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
      "--disable-libtool",
    ]
    args << "--with-command-group=_www" if OS.mac?

    system "./configure", *std_configure_args, *args
    system "make", "all"
    system "make", "install"

    # Install config
    system "make", "install-config"
    system "make", "install-webconf"
  end

  def post_install
    (var/"lib/nagios/rw").mkpath

    config = etc/"nagios/nagios.cfg"
    return unless config.exist?
    return if config.read.include?("nagios_user=#{ENV["USER"]}")

    inreplace config, /^nagios_user=.*/, "nagios_user=#{ENV["USER"]}"
  end

  service do
    run [opt_bin/"nagios", etc/"nagios/nagios.cfg"]
    keep_alive true
    require_root true
    log_path "/dev/null"
    error_log_path "/dev/null"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nagios --version")
  end
end