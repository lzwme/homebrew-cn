class Trafficserver < Formula
  desc "HTTP/1.1 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://downloads.apache.org/trafficserver/trafficserver-9.2.2.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-9.2.2.tar.bz2"
  sha256 "5960dd2d075e8f1c71d299a09155ca8ed6dd02af1d39678e7379c1e5bd81c388"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "ead1ae3a4043e2d6280239fa83e5466febec54ab7cc0b878b6ff8e437e5c4864"
    sha256 arm64_monterey: "04fdb16031a006c727c7220100d50aa5ee85e15c86cae0bf296649c1f54f26bd"
    sha256 arm64_big_sur:  "de42b001e9b0d634319f21936d8a03cfefc565f4225f64fdc2c4b5f4c9f9360e"
    sha256 ventura:        "cb30731d87ec6e311ebec4ed9fb8e8713b76ea88e5d0c7d548beefffddaebe79"
    sha256 monterey:       "48c7f1a10d674aa560a59a2cf7cf77716405cb7b767ebe21f34e975e7d962770"
    sha256 big_sur:        "c1bbc06a2e060403f8421b7a03ff09f5e9017bed6498d73a11590884b7dfabd8"
    sha256 x86_64_linux:   "374a0d6b06faf0e992a5b8822a08b6d6f801e02ef08c2d627320cbf42741a282"
  end

  head do
    url "https://github.com/apache/trafficserver.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkg-config" => :build
  depends_on "hwloc"
  depends_on macos: :mojave # `error: call to unavailable member function 'value': introduced in macOS 10.14`
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "yaml-cpp"

  on_macos do
    # Need to regenerate configure to fix macOS 11+ build error due to undefined symbols
    # See https://github.com/apache/trafficserver/pull/8556#issuecomment-995319215
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  fails_with gcc: "5" # needs C++17

  fails_with :clang do
    build 800
    cause "needs C++17"
  end

  def install
    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s

    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --localstatedir=#{var}
      --sysconfdir=#{pkgetc}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --with-yaml-cpp=#{Formula["yaml-cpp"].opt_prefix}
      --with-group=admin
      --disable-tests
      --disable-silent-rules
      --enable-experimental-plugins
    ]

    system "autoreconf", "-fvi" if build.head? || OS.mac?
    system "./configure", *args

    # Fix wrong username in the generated startup script for bottles.
    inreplace "rc/trafficserver.in", "@pkgsysuser@", "$USER"

    inreplace "lib/perl/Makefile",
      "Makefile.PL INSTALLDIRS=$(INSTALLDIRS)",
      "Makefile.PL INSTALLDIRS=$(INSTALLDIRS) INSTALLSITEMAN3DIR=#{man3}"

    system "make" if build.head?
    system "make", "install"
  end

  def post_install
    (var/"log/trafficserver").mkpath
    (var/"trafficserver").mkpath

    config = etc/"trafficserver/records.config"
    return unless File.exist?(config)
    return if File.read(config).include?("proxy.config.admin.user_id STRING #{ENV["USER"]}")

    config.append_lines "CONFIG proxy.config.admin.user_id STRING #{ENV["USER"]}"
  end

  test do
    if OS.mac?
      output = shell_output("#{bin}/trafficserver status")
      assert_match "Apache Traffic Server is not running", output
    else
      output = shell_output("#{bin}/trafficserver status 2>&1", 3)
      assert_match "traffic_manager is not running", output
    end
  end
end