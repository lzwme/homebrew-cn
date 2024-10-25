class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nagios-4.x/nagios-4.5.7/nagios-4.5.7.tar.gz"
  sha256 "83da5f1e4fc4d864e18916ef3809df42fb2917a8629d311ae574b3fe2b841db5"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/nagios[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "54c32dc527dd7af04e3342067757564e2a65f82d2fe86d7a5e9ae6acf8ade110"
    sha256 arm64_sonoma:  "9927fee4a339eeec23b3bdcf406482bd65bc853d2f82f0ac4709e9c06f786b1e"
    sha256 arm64_ventura: "63336ee3e17ee07b143311ddd639af869d44206c0fb12386dd760fc5bc1ea3cf"
    sha256 sonoma:        "508f4868f8290a86cd20b384ed884aebbef8fb791b7bf2cb8382095ee6c15180"
    sha256 ventura:       "a543302c16e445538e5cc0d0068d41ace40e0c4713f11977a1fe4dff1b8587ae"
    sha256 x86_64_linux:  "3175ce1df62fa7c15f8e1a65ac53635a5d2a39a8ca4fef39277dbb67b9ac7d88"
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