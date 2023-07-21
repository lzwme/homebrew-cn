class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.20.0/pgbouncer-1.20.0.tar.gz"
  sha256 "e70d5a7cb8b71dd7dbabfd3571d71a4b6b99f2e85d8d71af1e734f6d86635f0e"
  license "ISC"

  livecheck do
    url "https://www.pgbouncer.org/downloads/"
    regex(/href=.*?pgbouncer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "678c855f5a11ebe943f4a165786ad8b3f65d4612c9bda2d7b53b440be7f2a5b9"
    sha256 cellar: :any,                 arm64_monterey: "2612b6774d497faaa80c60927f11f548099177e0d3f0da8930e315c1afc91952"
    sha256 cellar: :any,                 arm64_big_sur:  "afd7afc41e06281a7e5fb56f3e588eb2323cb3d1a62f7bd616afc532832b52e3"
    sha256 cellar: :any,                 ventura:        "8f978ff96283a4eec7561796e41e669769dc3b0da1494fe2af04215888385ed8"
    sha256 cellar: :any,                 monterey:       "f1d9936d06f2e8a522200b06d627abc8ccd4725e8648f50bb3c3193b9d2348c1"
    sha256 cellar: :any,                 big_sur:        "435e530526b9dcf1544387365598c9be05dc5b1db13a31907cabedbec3e719d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11ad4edce408f1cc888b9af62d2e44a9c601636e7139ddb805b93a378ad94c35"
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
  depends_on "openssl@3"

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