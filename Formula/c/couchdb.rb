class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.4.2/apache-couchdb-3.4.2.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.4.2/apache-couchdb-3.4.2.tar.gz"
  sha256 "d27ff2a13356000296a98ab884caf3d175927cf21727963ff90fab3a747544cf"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1500ffea5ffb4a8cb8256b8854f01f76e7684cabe18e8ce920ab655d16c25186"
    sha256 cellar: :any,                 arm64_sonoma:  "c094486ec804d2d93cc3e0c7cffa2f403bdf91dc141b14d3970d81276cff0607"
    sha256 cellar: :any,                 arm64_ventura: "3b31f2fe9e0bb4ced33661ce033b0191a3463c38cf15374e941f689688eead5a"
    sha256 cellar: :any,                 sonoma:        "2ab357abc3419335515cea1523ba073424335726381c8607cc499318bc425272"
    sha256 cellar: :any,                 ventura:       "1745ccc788a6d72add9b3905c21f213f6bf654b6735bc77fb34fd75c0f8ea577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f571fe632ce980aabe811d1913de2884cd300ee30f251300b1c6a512e290970"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "erlang" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c@75"
  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  conflicts_with "ejabberd", because: "both install `jiffy` lib"

  fails_with :gcc do
    version "5"
    cause "mfbt (and Gecko) require at least gcc 6.1 to build."
  end

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