class Orientdb < Formula
  desc "Graph database"
  homepage "https:github.comorientechnologiesorientdb"
  url "https:search.maven.orgremotecontent?filepath=comorientechnologiesorientdb-community3.2.38orientdb-community-3.2.38.zip"
  sha256 "1dd9439951e6381dc8c60401530e58da508a9ce0cdfdbf512c14592d117ca95a"
  license "Apache-2.0"

  # The GitHub release description contains links to files on Maven.
  livecheck do
    url :homepage
    regex(orientdb-community[._-]v?(\d+(?:\.\d+)+)\.zipi)
    strategy :github_latest do |json, regex|
      json["body"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a569d2c17fcea9ddc0abb9a7495e8cf27b6b91bcb51a01efc2981dac0376f894"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    rm_r(Dir["bin*.bat"])

    chmod 0755, Dir["bin*"]
    libexec.install Dir["*"]

    inreplace "#{libexec}configorientdb-server-config.xml", "<properties>",
       <<~EOS
         <entry name="server.database.path" value="#{var}dborientdb" >
         <properties>
       EOS
    inreplace "#{libexec}configorientdb-server-log.properties", "..log", "#{var}logorientdb"
    inreplace "#{libexec}binorientdb.sh", "..log", "#{var}logorientdb"
    inreplace "#{libexec}binserver.sh", "ORIENTDB_PID=$ORIENTDB_HOMEbin", "ORIENTDB_PID=#{var}runorientdb"
    inreplace "#{libexec}binshutdown.sh", "ORIENTDB_PID=$ORIENTDB_HOMEbin", "ORIENTDB_PID=#{var}runorientdb"
    inreplace "#{libexec}binorientdb.sh", '"YOUR_ORIENTDB_INSTALLATION_PATH"', libexec
    inreplace "#{libexec}binorientdb.sh", 'su $ORIENTDB_USER -c "cd \"$ORIENTDB_DIRbin\";', ""
    inreplace "#{libexec}binorientdb.sh", '&"', "&"

    (bin"orientdb").write_env_script "#{libexec}binorientdb.sh", JAVA_HOME: Formula["openjdk"].opt_prefix
    (bin"orientdb-console").write_env_script "#{libexec}binconsole.sh", JAVA_HOME: Formula["openjdk"].opt_prefix
    (bin"orientdb-gremlin").write_env_script "#{libexec}bingremlin.sh", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  def post_install
    (var"dborientdb").mkpath
    (var"runorientdb").mkpath
    (var"logorientdb").mkpath
    touch "#{var}logorientdborientdb.err"
    touch "#{var}logorientdborientdb.log"

    ENV["ORIENTDB_ROOT_PASSWORD"] = "orientdb"
    system bin"orientdb", "stop"
    sleep 3
    system bin"orientdb", "start"
    sleep 3
  ensure
    system bin"orientdb", "stop"
  end

  def caveats
    <<~EOS
      The OrientDB root password was set to 'orientdb'. To reset it:
        https:orientdb.orgdocs3.1.xsecurityServer-Security.html#restoring-the-servers-user-root
    EOS
  end

  service do
    run opt_libexec"binserver.sh"
    keep_alive true
    working_dir var
    log_path var"logorientdbsout.log"
    error_log_path var"logorientdbserror.log"
  end

  test do
    ENV["CONFIG_FILE"] = "#{testpath}orientdb-server-config.xml"
    ENV["ORIENTDB_ROOT_PASSWORD"] = "orientdb"

    cp "#{libexec}configorientdb-server-config.xml", testpath
    inreplace "#{testpath}orientdb-server-config.xml", "<properties>",
      "  <entry name=\"server.database.path\" value=\"#{testpath}\" >\n    <properties>"

    assert_match "OrientDB console v.#{version}", pipe_output("#{bin}orientdb-console \"exit;\"")
  end
end