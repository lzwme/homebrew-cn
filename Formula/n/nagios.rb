class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nagios-4.x/nagios-4.5.5/nagios-4.5.5.tar.gz"
  sha256 "a3699ab615ccc85cdd5292403c672a996bcb919ed40580a291b44db4aa04cd7a"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/nagios[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "81bcf2c734ebb1e0b47191c6c40a43d5a51bcc1822d084a3db57369f1d24f300"
    sha256 arm64_sonoma:  "e0fb63a240d377607a334d8fd95bd57c6e5eb2c31812762da5727fcfc8d9446e"
    sha256 arm64_ventura: "1b8b6e0df30add7d61867ffb0b8ba3c4b4084dc3535eb3a9138d847dd4f0956f"
    sha256 sonoma:        "b8b38f4237275a6bd9ace583d8ed94c87607c95472c2e0946cfbb1e05fceb9b4"
    sha256 ventura:       "cf116a7030edfd2db06fa2fc0642d6536c8433942d66f6f0aa3bf9bee6fee71d"
    sha256 x86_64_linux:  "11b49fd6743839534b904143c69411c23c34f05d8cc79033552ccbe979d6ec62"
  end

  depends_on "gd"
  depends_on "libpng"
  depends_on "openssl@3"

  uses_from_macos "unzip"

  on_macos do
    depends_on "jpeg-turbo"
  end

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