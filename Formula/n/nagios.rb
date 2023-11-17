class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nagios-4.x/nagios-4.5.0/nagios-4.5.0.tar.gz"
  sha256 "164e05daed1adf72640b323453b6c13f4d13d90e56a95c7cdd8dccf8519e9be0"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/nagios[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "fac16770fceb5dc796e07427d006261c47f9e8e084a577118bef1fadb210f805"
    sha256 arm64_ventura:  "d0a745b8100973c75c3013c2d40b691d02058388d0110668631eaabcab05e6d4"
    sha256 arm64_monterey: "8fb3a223ca64852cc84dd3a34985435f54abf3823d07b93864af75bcf9cba0ed"
    sha256 sonoma:         "6838724bfa5d54827819b93b8c2b17ccf587a2fc935e0a3d7a7e54dc43c78da0"
    sha256 ventura:        "806b52732cae2adaecbe3b729b843ce9187044938374766f1714a984079f613e"
    sha256 monterey:       "e490add403bd13f5a7d4dff3da9cf14eb76d9b82a379e7c6698057444f276ec3"
    sha256 x86_64_linux:   "b9b02f0d1200fb941d85a1ba5d3cbcd5cc67ffcffa64e841a9a55beb8c8e949b"
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