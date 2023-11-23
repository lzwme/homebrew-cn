class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  # TODO: Check if we can use unversioned `erlang` at version bump.
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.3.2/apache-couchdb-3.3.2.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.3.2/apache-couchdb-3.3.2.tar.gz"
  sha256 "3d6823d42d10cf0d4f86c9c4fe59c9932c89d68578fcb6c4b4278dc769308daa"
  license "Apache-2.0"
  revision 3

  livecheck do
    url :homepage
    regex(/href=.*?apache-couchdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b90a5873d9b75314e113d434723fc78db182888fe7242026ac9d9a376e47e02c"
    sha256 cellar: :any,                 arm64_ventura:  "abeaffd7a14c30a3f006a08b8948cf24b33a017037b1d331fb5d8375aadb518c"
    sha256 cellar: :any,                 arm64_monterey: "14312031254ffe2b155c2b062d473dee60a25aae0d10886b70d36d7d5df88d1c"
    sha256 cellar: :any,                 sonoma:         "66f99c4c62f269589ee9fc59c7cc7ea410051af18730a078449f20c556bef1dd"
    sha256 cellar: :any,                 ventura:        "1ddd27752cd1a79e08383e9fe080d0e4da38b63d5a23aba6af426afb02e37b71"
    sha256 cellar: :any,                 monterey:       "d12f6761c30f1b5a0ca8c750cd7fc4f4220a5758a89f79534db5559c73334040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8353237aacf263acce6dc2044e6e652edbc03461c957d214aa258059cc2b89b1"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "erlang@25" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl@3"
  # NOTE: Supported `spidermonkey` versions are hardcoded at
  # https://github.com/apache/couchdb/blob/#{version}/src/couch/rebar.config.script
  depends_on "spidermonkey@91"

  conflicts_with "ejabberd", because: "both install `jiffy` lib"

  fails_with :gcc do
    version "5"
    cause "mfbt (and Gecko) require at least gcc 6.1 to build."
  end

  def install
    spidermonkey = Formula["spidermonkey@91"]
    inreplace "configure", '[ ! -d "/usr/local/include/${SM_HEADERS}" ]',
                           "[ ! -d \"#{spidermonkey.opt_include}/${SM_HEADERS}\" ]"
    inreplace "src/couch/rebar.config.script" do |s|
      s.gsub! "-I/usr/local/include/mozjs", "-I#{spidermonkey.opt_include}/mozjs"
      s.gsub! "-L/usr/local/lib", "-L#{spidermonkey.opt_lib} -L#{HOMEBREW_PREFIX}/lib"
    end

    system "./configure", "--spidermonkey-version", spidermonkey.version.major.to_s
    system "make", "release"
    # setting new database dir
    inreplace "rel/couchdb/etc/default.ini", "./data", "#{var}/couchdb/data"
    # remove windows startup script
    rm_rf("rel/couchdb/bin/couchdb.cmd")
    # install files
    prefix.install Dir["rel/couchdb/*"]
    if File.exist?(prefix/"Library/LaunchDaemons/org.apache.couchdb.plist")
      (prefix/"Library/LaunchDaemons/org.apache.couchdb.plist").delete
    end
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