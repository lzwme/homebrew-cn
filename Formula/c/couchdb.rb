class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.4.2/apache-couchdb-3.4.2.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.4.2/apache-couchdb-3.4.2.tar.gz"
  sha256 "d27ff2a13356000296a98ab884caf3d175927cf21727963ff90fab3a747544cf"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "06b02add6e120e4df95c2eb6073c83f06f528513f5af9c3fb4c0e800f345428e"
    sha256 cellar: :any,                 arm64_sonoma:  "fad551c743492776a307e4bddfd3e1e362a640eef3d168e229781109433fb60f"
    sha256 cellar: :any,                 arm64_ventura: "3ee4eca7d8bbd049d283e4cd158d4c2011de978a46f808b4dcbed6fbb4a7ff39"
    sha256 cellar: :any,                 sonoma:        "fd88d185441c311938997a7ec5c93b50a1247a49868c6190b25be2e28ad61620"
    sha256 cellar: :any,                 ventura:       "e2c31acb9b022927dd5f47e892be61fd0b5a2ab4d2b56157772cd5484b18a937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00d08debcab99db20dfeeecd0a6a3058d38b21b23cb763441f8c79bd7cca3343"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "erlang" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@77"
  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  conflicts_with "ejabberd", because: "both install `jiffy` lib"

  def install
    system "./configure", "--disable-spidermonkey", "--js-engine=quickjs"
    system "make", "release"
    # setting new database dir
    inreplace "rel/couchdb/etc/default.ini", "./data", "#{var}/couchdb/data"
    # remove windows startup script
    rm("rel/couchdb/bin/couchdb.cmd")
    # install files
    prefix.install Dir["rel/couchdb/*"]
  end

  def post_install
    # creating database directory
    (var/"couchdb/data").mkpath
  end

  def caveats
    <<~EOS
      CouchDB 3.x requires a set admin password set before startup.
      Add one to your #{etc}/local.ini before starting CouchDB e.g.:
        [admins]
        admin = youradminpassword
    EOS
  end

  service do
    run opt_bin/"couchdb"
    keep_alive true
  end

  test do
    cp_r prefix/"etc", testpath
    port = free_port
    inreplace "#{testpath}/etc/default.ini", "port = 5984", "port = #{port}"
    inreplace "#{testpath}/etc/default.ini", "#{var}/couchdb/data", "#{testpath}/data"
    inreplace "#{testpath}/etc/local.ini", ";admin = mysecretpassword", "admin = mysecretpassword"

    fork do
      exec "#{bin}/couchdb -couch_ini #{testpath}/etc/default.ini #{testpath}/etc/local.ini"
    end
    sleep 30

    output = JSON.parse shell_output("curl --silent localhost:#{port}")
    assert_equal "Welcome", output["couchdb"]
  end
end