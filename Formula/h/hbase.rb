class Hbase < Formula
  desc "Hadoop database: a distributed, scalable, big data store"
  homepage "https:hbase.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=hbase2.6.1hbase-2.6.1-bin.tar.gz"
  mirror "https:archive.apache.orgdisthbase2.6.1hbase-2.6.1-bin.tar.gz"
  sha256 "76e6eeff822593cd8db4d11c2adf2e2db707f27f351277313af9193b09369150"
  # We bundle hadoop-lzo which is GPL-3.0-or-later
  license all_of: ["Apache-2.0", "GPL-3.0-or-later"]

  bottle do
    sha256 arm64_sequoia: "ef9abda0df4a73dc7dc79fc84bafb0458a28bd9214152f2c94724b40ebb3a6b5"
    sha256 arm64_sonoma:  "2e29b17434154655014f2748b84333fade9c3a147ad0283cbe2dae9ec90659b6"
    sha256 arm64_ventura: "29e6c268eae626c43cf0c0e56ade1fbbdf30a69368f05dc3c615db1a3164c431"
    sha256 sonoma:        "47438928d3738dc6e906ea0665bc851d1795ffa865fb66b5938395cde0833ea4"
    sha256 ventura:       "c33cf0818f374ef77bcfc09ce58a1eb7ccaea69dadf24aaeebdd99e79a8ec043"
    sha256 x86_64_linux:  "d779413909edc9803f495fcb53eee1414e0f98f8b4496761df4350fdb6e4e767"
  end

  depends_on "ant" => :build
  depends_on "lzo"
  depends_on "openjdk@11"

  uses_from_macos "netcat" => :test

  resource "hadoop-lzo" do
    url "https:github.comclouderahadoop-lzoarchiverefstags0.4.14.tar.gz"
    sha256 "aa8ddbb8b3f9e1c4b8cc3523486acdb7841cd97c002a9f2959c5b320c7bb0e6c"

    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patchesb89da3afad84bbf69deed0611e5dddaaa5d39325hbasebuild.xml.patch"
      sha256 "d1d65330a4367db3e17ee4f4045641b335ed42449d9e6e42cc687e2a2e3fa5bc"
    end

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
      directory "srcnative"
    end
  end

  def install
    java_home = Language::Java.java_home("11")
    rm(Dir["bin*.cmd", "conf*.cmd"])
    libexec.install %w[bin conf lib hbase-webapps]

    # Some binaries have really generic names (like `test`) and most seem to be
    # too special-purpose to be permanently available via PATH.
    %w[hbase start-hbase.sh stop-hbase.sh].each do |script|
      (binscript).write_env_script libexec"bin"script, Language::Java.overridable_java_home_env("11")
    end

    resource("hadoop-lzo").stage do
      # Help configure to find liblzo on Linux.
      unless OS.mac?
        inreplace "srcnativeconfigure",
        "#define HADOOP_LZO_LIBRARY ${ac_cv_libname_lzo2}",
        "#define HADOOP_LZO_LIBRARY \"#{Formula["lzo"].opt_libshared_library("liblzo2")}\""
      end

      # Fixed upstream: https:github.comclouderahadoop-lzoblobHEADbuild.xml#L235
      ENV["CLASSPATH"] = Dir["#{libexec}libhadoop-common-*.jar"].first
      # Workaround for Xcode 14.3.
      ENV["CFLAGS"] = "-m64 -Wno-implicit-function-declaration"
      ENV["CXXFLAGS"] = "-m64"
      ENV["CPPFLAGS"] = "-I#{Formula["openjdk@11"].include}"
      system "ant", "compile-native", "tar"
      (libexec"lib").install Dir["buildhadoop-lzo-*hadoop-lzo-*.jar"]
      (libexec"libnative").install Dir["buildhadoop-lzo-*libnative*"]
    end

    inreplace libexec"confhbase-env.sh" do |s|
      # upstream bugs for ipv6 incompatibility:
      # https:issues.apache.orgjirabrowseHADOOP-8568
      # https:issues.apache.orgjirabrowseHADOOP-3619
      s.gsub!(^# export HBASE_OPTS$,
              "export HBASE_OPTS=\"-Djava.net.preferIPv4Stack=true -XX:+UseConcMarkSweepGC\"")
      s.gsub!(^# export JAVA_HOME=.*,
              "export JAVA_HOME=\"${JAVA_HOME:-#{java_home}}\"")

      # Default `$HBASE_HOMElogs` is unsuitable as it would cause writes to the
      # formula's prefix. Provide a better default but still allow override.
      s.gsub!(^# export HBASE_LOG_DIR=.*$,
              "export HBASE_LOG_DIR=\"${HBASE_LOG_DIR:-#{var}loghbase}\"")
    end

    # Interface name is lo on Linux, not lo0.
    loopback = OS.mac? ? "lo0" : "lo"
    # makes hbase usable out of the box
    # upstream has been provided this patch
    # https:issues.apache.orgjirabrowseHBASE-15426
    inreplace "#{libexec}confhbase-site.xml",
      <configuration>,
      <<~EOS
        <configuration>
          <property>
            <name>hbase.rootdir<name>
            <value>file:#{var}hbase<value>
          <property>
          <property>
            <name>hbase.zookeeper.property.clientPort<name>
            <value>2181<value>
          <property>
          <property>
            <name>hbase.zookeeper.property.dataDir<name>
            <value>#{var}zookeeper<value>
          <property>
          <property>
            <name>hbase.zookeeper.dns.interface<name>
            <value>#{loopback}<value>
          <property>
          <property>
            <name>hbase.regionserver.dns.interface<name>
            <value>#{loopback}<value>
          <property>
          <property>
            <name>hbase.master.dns.interface<name>
            <value>#{loopback}<value>
          <property>
      EOS
  end

  def post_install
    (var"loghbase").mkpath
    (var"runhbase").mkpath
  end

  service do
    run [opt_bin"hbase", "--config", opt_libexec"conf", "master", "start"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var"hbasehbase.log"
    error_log_path var"hbasehbase.err"
    environment_variables HBASE_HOME:              opt_libexec,
                          HBASE_IDENT_STRING:      "root",
                          HBASE_LOG_DIR:           var"hbase",
                          HBASE_LOG_PREFIX:        "hbase-root-master",
                          HBASE_LOGFILE:           "hbase-root-master.log",
                          HBASE_MASTER_OPTS:       " -XX:PermSize=128m -XX:MaxPermSize=128m",
                          HBASE_NICENESS:          "0",
                          HBASE_OPTS:              "-XX:+UseConcMarkSweepGC",
                          HBASE_PID_DIR:           var"runhbase",
                          HBASE_REGIONSERVER_OPTS: " -XX:PermSize=128m -XX:MaxPermSize=128m",
                          HBASE_ROOT_LOGGER:       "INFO,RFA",
                          HBASE_SECURITY_LOGGER:   "INFO,RFAS"
  end

  test do
    port = free_port
    assert_match "HBase #{version}", shell_output("#{bin}hbase version 2>&1")

    cp_r (libexec"conf"), testpath
    inreplace (testpath"confhbase-site.xml") do |s|
      s.gsub!((hbase.rootdir.*)\n.*, "\\1\n<value>file:#{testpath}hbase<value>")
      s.gsub!((hbase.zookeeper.property.dataDir.*)\n.*, "\\1\n<value>#{testpath}zookeeper<value>")
      s.gsub!((hbase.zookeeper.property.clientPort.*)\n.*, "\\1\n<value>#{port}<value>")
    end

    ENV["HBASE_LOG_DIR"]  = testpath"logs"
    ENV["HBASE_CONF_DIR"] = testpath"conf"
    ENV["HBASE_PID_DIR"]  = testpath"pid"

    system bin"start-hbase.sh"
    sleep 15
    begin
      assert_match "Zookeeper", pipe_output("nc 127.0.0.1 #{port} 2>&1", "stats")
    ensure
      system bin"stop-hbase.sh"
    end
  end
end