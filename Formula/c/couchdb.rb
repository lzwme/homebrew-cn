class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.5.2/apache-couchdb-3.5.2.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.5.2/apache-couchdb-3.5.2.tar.gz"
  sha256 "e561102aaadfdda1e499e6e9e12d2473433291b608bcd390bcbcf590bbb6cf68"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "ca5ca7f5e71f16d1357b4b556c7c31463959118a33764acd445e6b53e26599e1"
    sha256 cellar: :any, arm64_tahoe:       "48f2ae643eeb235bb2a70c5e1a2db90377bbdff21924f3de11e6b8f93f06a175"
    sha256 cellar: :any, arm64_sequoia:     "3d7a7c55b9bf5cce01bb8a0328e946871d4adebad3178b7de5260ce30bb9d73c"
    sha256 cellar: :any, arm64_linux:       "85c85bda4579e617663b08576636f9f535ea418971ced5453e6c365b2f62f9a3"
    sha256 cellar: :any, x86_64_linux:      "e323311e757733ef6701b0eda3351d6bfb71560bcdc387bf454afcb2f66111e5"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "erlang@28" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
  depends_on "openssl@4"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    inreplace "etc/local.ini", ";admin = mysecretpassword", "admin = mysecretpassword"
    inreplace "etc/default.ini" do |s|
      s.gsub! "port = 5984", "port = #{port}"
      s.gsub! "#{var}/couchdb/data", testpath/"data"
    end

    spawn bin/"couchdb", "-couch_ini", testpath/"etc/default.ini", testpath/"etc/local.ini"
    output = JSON.parse(shell_output("curl --silent --retry 5 --retry-connrefused localhost:#{port}"))
    assert_equal "Welcome", output["couchdb"]
  end
end