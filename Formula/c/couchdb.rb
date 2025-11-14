class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.5.1/apache-couchdb-3.5.1.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.5.1/apache-couchdb-3.5.1.tar.gz"
  sha256 "c22cf31d6d91a3f5aa04f0cad493babdc723213494cb5e6170a507d359c50136"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "97b1573e32fb1da37a5253623b38a3aa42b40bd6bb1b5718b1dea8186ab777be"
    sha256 cellar: :any,                 arm64_sequoia: "9085a4adcf7c67f6aa95cdbc06144070f80a00eaa088d9906510b830cd0aee8f"
    sha256 cellar: :any,                 arm64_sonoma:  "cd534b8b0d47fa6dcbca54914ae3b3cc56530196d6fdcc76b84d97ebc527d5f2"
    sha256 cellar: :any,                 sonoma:        "053f692655f1b10d59f30cfb7bf2d9ba977d3ec76845b7db86f4652a6bb1cd2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a5583eef463cc96ac241d8c4c0a3b326a3ead5c85295f58ab611938ced493dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed84543239fd30060f87a2db5122d183902070af334c9d65ead33bf18a8ddb93"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "erlang" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
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