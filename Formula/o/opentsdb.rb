class Opentsdb < Formula
  desc "Scalable, distributed Time Series Database"
  homepage "http:opentsdb.net"
  url "https:github.comOpenTSDBopentsdbarchiverefstagsv2.4.1.tar.gz"
  sha256 "70456fa8b33a9f0855105422f944d6ef14d077c4b4c9c26f8e4a86f329b247a0"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, ventura:  "64369af5327cbbbed6c3f3845e6e60f399a9876cacef624682e8d7cfc9d804b9"
    sha256 cellar: :any_skip_relocation, monterey: "98c4251b26aaa0d592c976615aa53d4d4ff0a464b342421e91354a4138dcd208"
    sha256 cellar: :any_skip_relocation, big_sur:  "e29c00cec680bfc711c31d40aa5f04e5c62ebf9219c3adddcc84dff74b1922cc"
    sha256 cellar: :any_skip_relocation, catalina: "61cd7a6e22f917bd544d427d77e7236c82735406ea384134ba0551a70ce10b27"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openjdk@8" => :build
  depends_on "python@3.12" => :build
  depends_on "gnuplot"
  depends_on "hbase"
  depends_on "lzo"
  depends_on "openjdk@11"

  def install
    with_env(JAVA_HOME: Language::Java.java_home("1.8")) do
      ENV.prepend_path "PATH", Formula["python@3.12"].opt_libexec"bin"
      system "autoreconf", "--force", "--install", "--verbose"
      system ".configure", *std_configure_args,
                            "--disable-silent-rules",
                            "--mandir=#{man}",
                            "--sysconfdir=#{etc}",
                            "--localstatedir=#{var}opentsdb"
      system "make"
      bin.mkpath
      (pkgshare"staticgwtopentsdbimagesie6").mkpath
      ENV.deparallelize { system "make", "install" }
    end

    env = Language::Java.java_home_env("11")
    env["PATH"] = "$JAVA_HOMEbin:$PATH"
    env["HBASE_HOME"] = Formula["hbase"].opt_libexec
    # We weren't able to get HBase native LZO compression working in Monterey
    env["COMPRESSION"] = (OS.mac? && MacOS.version >= :monterey) ? "NONE" : "LZO"

    create_table = pkgshare"toolscreate_table_with_env.sh"
    create_table.write_env_script pkgshare"toolscreate_table.sh", env
    create_table.chmod 0755

    inreplace pkgshare"etcopentsdbopentsdb.conf", "usrshare", "#{HOMEBREW_PREFIX}share"
    etc.install pkgshare"etcopentsdb"
    (pkgshare"plugins.keep").write ""

    (bin"start-tsdb.sh").write <<~EOS
      #!binsh
      exec "#{opt_bin}tsdb" tsd \\
        --config="#{etc}opentsdbopentsdb.conf" \\
        --staticroot="#{opt_pkgshare}static" \\
        --cachedir="#{var}cacheopentsdb" \\
        --port=4242 \\
        --zkquorum=localhost:2181 \\
        --zkbasedir=hbase \\
        --auto-metric \\
        "$@"
    EOS
    (bin"start-tsdb.sh").chmod 0755

    libexec.mkpath
    bin.env_script_all_files(libexec, env)
  end

  def post_install
    (var"cacheopentsdb").mkpath
    system "#{Formula["hbase"].opt_bin}start-hbase.sh"
    begin
      sleep 2
      system "#{pkgshare}toolscreate_table_with_env.sh"
    ensure
      system "#{Formula["hbase"].opt_bin}stop-hbase.sh"
    end
  end

  service do
    run opt_bin"start-tsdb.sh"
    working_dir HOMEBREW_PREFIX
    log_path var"opentsdbopentsdb.log"
    error_log_path var"opentsdbopentsdb.err"
  end

  test do
    cp_r (Formula["hbase"].opt_libexec"conf"), testpath
    inreplace (testpath"confhbase-site.xml") do |s|
      s.gsub!((hbase.rootdir.*)\n.*, "\\1\n<value>file:#{testpath}hbase<value>")
      s.gsub!((hbase.zookeeper.property.dataDir.*)\n.*, "\\1\n<value>#{testpath}zookeeper<value>")
    end

    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}tmp"
    ENV["HBASE_LOG_DIR"]  = testpath"logs"
    ENV["HBASE_CONF_DIR"] = testpath"conf"
    ENV["HBASE_PID_DIR"]  = testpath"pid"

    system "#{Formula["hbase"].opt_bin}start-hbase.sh"
    begin
      sleep 10

      system pkgshare"toolscreate_table_with_env.sh"

      tsdb_err = testpath"tsdb.err"
      tsdb_out = testpath"tsdb.out"
      fork do
        $stderr.reopen(tsdb_err, "w")
        $stdout.reopen(tsdb_out, "w")
        exec("#{bin}start-tsdb.sh")
      end
      sleep 15

      pipe_output("nc localhost 4242 2>&1", "put homebrew.install.test 1356998400 42.5 host=webserver01 cpu=0\n")

      system bin"tsdb", "query", "1356998000", "1356999000", "sum",
             "homebrew.install.test", "host=webserver01", "cpu=0"
    ensure
      system "#{Formula["hbase"].opt_bin}stop-hbase.sh"
    end
  end
end