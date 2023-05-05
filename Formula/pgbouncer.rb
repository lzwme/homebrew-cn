class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.19.0/pgbouncer-1.19.0.tar.gz"
  sha256 "af0b05e97d0e1fd9ad45fe00ea6d2a934c63075f67f7e2ccef2ca59e3d8ce682"
  license "ISC"

  livecheck do
    url "https://www.pgbouncer.org/downloads/"
    regex(/href=.*?pgbouncer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f0a6bb79e071212bdf50f21d224edbd84afd566b808a3a6ea676b56d8cb0f18e"
    sha256 cellar: :any,                 arm64_monterey: "7d82440a362a6ebac180d9ad5e2af532662c049ec847ae772cb3905484cbd9d5"
    sha256 cellar: :any,                 arm64_big_sur:  "f983c75a8093a997a0a64eb43397e5c7262a6e223fbed6620f0f60760abc2199"
    sha256 cellar: :any,                 ventura:        "e74e4a91f0a9b3fed3c2ef30d0bd4bc2fa3f42f83ee72485db8b714926b92ac9"
    sha256 cellar: :any,                 monterey:       "bf848abda50056bd8840027e3fa9576ec9bc7ca531ae8365c500b9302e106515"
    sha256 cellar: :any,                 big_sur:        "6bde5b1280d75d03d8e39ceba114769f187cff80f7bc390cb36905d6903c8fd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd1d84f90b9fc6f4fe3532a8034090b410dba6cb7baa01aebbb6da4833780ba6"
  end

  head do
    url "https://github.com/pgbouncer/pgbouncer.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pandoc" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl@1.1"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
    bin.install "etc/mkauth.py"
    inreplace "etc/pgbouncer.ini" do |s|
      s.gsub!(/logfile = .*/, "logfile = #{var}/log/pgbouncer.log")
      s.gsub!(/pidfile = .*/, "pidfile = #{var}/run/pgbouncer.pid")
      s.gsub!(/auth_file = .*/, "auth_file = #{etc}/userlist.txt")
    end
    etc.install %w[etc/pgbouncer.ini etc/userlist.txt]
  end

  def post_install
    (var/"log").mkpath
    (var/"run").mkpath
  end

  def caveats
    <<~EOS
      The config file: #{etc}/pgbouncer.ini is in the "ini" format and you
      will need to edit it for your particular setup. See:
      https://pgbouncer.github.io/config.html

      The auth_file option should point to the #{etc}/userlist.txt file which
      can be populated by the #{bin}/mkauth.py script.
    EOS
  end

  service do
    run [opt_bin/"pgbouncer", "-q", etc/"pgbouncer.ini"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pgbouncer -V")
  end
end