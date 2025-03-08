class Druid < Formula
  desc "High-performance, column-oriented, distributed data store"
  homepage "https:druid.apache.org"
  url "https:dlcdn.apache.orgdruid32.0.0apache-druid-32.0.0-bin.tar.gz"
  mirror "https:archive.apache.orgdistdruid32.0.0apache-druid-32.0.0-bin.tar.gz"
  sha256 "25e1e6ada58e40d8da558ca16107ac06bc0b1c0aa7aac106ea2b7aaae8f72b72"
  license "Apache-2.0"

  livecheck do
    url "https:druid.apache.orgdownloads"
    regex(href=.*?druid[._-]v?(\d+(?:\.\d+)+)-bin\.ti)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "22fe28b4fdeaf2a7cf63231974487412c0db31c302860c90d904450491fe6ae9"
  end

  depends_on "zookeeper" => :test
  depends_on "openjdk@17" # JDK 21 issue: https:github.comapachedruidissues17429

  resource "mysql-connector-java" do
    url "https:search.maven.orgremotecontent?filepath=commysqlmysql-connector-j8.2.0mysql-connector-j-8.2.0.jar"
    sha256 "06f14fbd664d0e382347489e66495ca27ab7e6c2e1d9969a496931736197465f"
  end

  def install
    rm_r "quickstarttutorial"
    libexec.install Dir["*"]

    %w[
      broker.sh
      coordinator.sh
      historical.sh
      middleManager.sh
      overlord.sh
    ].each do |sh|
      inreplace libexec"bin#{sh}", ".binnode.sh", libexec"binnode.sh"
    end

    inreplace libexec"binnode.sh" do |s|
      s.gsub! "nohup \"$BIN_DIRrun-java\"",
              "nohup \"$BIN_DIRrun-java\" -Ddruid.extensions.directory=\"#{libexec}extensions\""
      s.gsub! ":=lib", ":=#{libexec}lib"
      s.gsub! ":=confdruid", ":=#{libexec}confdruid"
      s.gsub! ":=${WHEREAMI}log", ":=#{var}druidlog"
      s.gsub! ":=vardruidpids", ":=#{var}druidpids"
    end

    resource("mysql-connector-java").stage do
      (libexec"extensionsmysql-metadata-storage").install Dir["*"]
    end

    bin.install Dir["#{libexec}bin*.sh"]
    bin.env_script_all_files libexec"bin", Language::Java.overridable_java_home_env("17")

    Pathname.glob("#{bin}*.sh") do |file|
      mv file, bin"druid-#{file.basename}"
    end
  end

  def post_install
    %w[
      druidhadoop-tmp
      druidindexing-logs
      druidlog
      druidpids
      druidsegments
      druidtask
    ].each do |dir|
      (vardir).mkpath
    end
  end

  test do
    ENV["DRUID_CONF_DIR"] = libexec"confdruidsingle-servernano-quickstart"
    ENV["DRUID_LOG_DIR"] = testpath
    ENV["DRUID_PID_DIR"] = testpath
    ENV["ZOO_LOG_DIR"] = testpath

    system Formula["zookeeper"].opt_bin"zkServer", "start"
    begin
      pid = fork { exec bin"druid-broker.sh", "start" }
      sleep 40
      output = shell_output("curl -s http:localhost:8082status")
      assert_match "version", output
    ensure
      system bin"druid-broker.sh", "stop"
      # force zookeeper stop since it is sometimes still alive after druid-broker.sh finishes
      system Formula["zookeeper"].opt_bin"zkServer", "stop"
      Process.wait pid
    end
  end
end